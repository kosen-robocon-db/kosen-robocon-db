class GamesController < ApplicationController
  before_action :logged_in_user,
    only: [ :new, :create, :edit, :update, :destroy ]
  before_action :admin_user, only: :index

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
    # 下記のコードはもっと洗練されるべき
    case @robot.contest_nth
      # GameDetail サブクラスのインスタンス生成
    when 29 then
      @game.send(@gd_sym).new(jury_votes: false, progress: false)
        # 審査員判定および課題進捗度チェックボックスを外しておく
        # 将来的にモデル内で処理
    when 30 then
      @game.send(@gd_sym).new(jury_votes: false)
    end
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: 0) #.pluck(:name, :round)
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    h = regularize(attrs_hash: game_params)
    h["robot_code"] = @robot.code.to_s
    h["code"] = Game.get_code(hash: h).to_s
    @game = Game.new(h)
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
    if @game.save then
      flash[:success] = "試合情報の新規作成成功"
      redirect_to robot_url(params[:robot_code])
    else
      render :new
    end
  end

  def edit
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.subjective_view_by(robot_code: @robot.code)
    @game.send(@gd_sym).each { |i| i.decompose_properties(@game.victory) }
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
    h = regularize(attrs_hash: game_params)
    # 下記のコードはもっと洗練されるべき
    if @game.region_code.to_i != h['region_code'].to_i or
      @game.round.to_i != h['round'].to_i or
      @game.game.to_i != h['game'].to_i then
      # game_code の変更がある場合
      h["robot_code"] = @robot.code.to_s
      h["code"] = Game.get_code(hash: h).to_s
      old_game_code = @game.code
      gdas = "#{@gd_sym.to_s}_attributes".to_sym
      h[gdas].each{ |i| # id を nil にしないと新しいレコードが登録されない
        h[gdas][i][:id] = nil
      }
      @game = Game.new(h)
      if @game.save then
        Game.find_by(code: old_game_code).destroy
        flash[:success] = "試合情報の編集成功"
        redirect_to robot_url(code: params[:robot_code])
      else
        render :edit
      end
    else
      # game_code の変更がない場合
      if @game.update(h) then
        flash[:success] = "試合情報の編集成功"
        redirect_to robot_url(code: params[:robot_code])
      else
        render :edit
      end
    end

  end

  def destroy
    Game.find_by(code: params[:code]).destroy
    flash[:success] = "試合情報の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  def index
    @games = Game.all
    respond_to do |format|
      format.csv { send_data @games.to_csv }
    end
  end

  # Canvasを使ったシングル・エリミネーション・ブラケットの描画検証
  def draw_bracket
    robots = Robot.where(contest_nth: 29, campus_code: 8000...9000).includes(:campus)
    gon.robots = robots
    gon.campuses = robots.map { |i| i.campus }
    games = Game.where(contest_nth: 29, region_code: 8).order(:round, :game)
    gon.games = games
    bracket = SingleElimination.new(games: games, robots: robots)
    gon.entries = bracket.entries
    # gon.lines = [ # 0:データなし 1:勝ち 2:負け 3:スルー
    #   [ # １回戦
    #     3, 3, 3, 1, 2, 3, 3, 3, 1, 2, 3, 3, 3, 1, 2, 3, 3, 3, 1, 2
    #   ],
    #   [ # ２回戦
    #     2, 1, 2, 1, 0, 1, 2, 1, 2, 0, 1, 2, 2, 1, 0, 1, 2, 1, 2, 0
    #   ],
    #   [ # ３回戦
    #     0, 2, 0, 1, 0, 2, 0, 1, 0, 0, 1, 0, 0, 2, 0, 1, 0, 2, 0, 0
    #   ],
    #   [ # 準決勝
    #     0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0
    #   ],
    #   [ # 決勝
    #     0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #   ]
    # ]
    gon.line_pairs = [
      [ # １回戦
        [3, 4, 3], [8, 9, 8], [13, 14, 13], [18, 19, 18]
      ],
      [ # ２回戦
        [0, 1, 1], [2, 3, 3], [7, 8, 7], [5, 6, 5],
        [10, 11, 10], [12, 13, 13], [15, 16, 16], [17, 18, 17]
      ],
      [ # ３回戦
        [1, 3, 3], [5, 7, 7], [10, 13, 10], [15, 17, 15]
      ],
      [ # 準決勝
        [3, 7, 3], [10, 15, 10]
      ],
      [ # 決勝
        [3, 10, 3]
      ]
    ]
  end

  private
  def game_params
    h = { "#{@gd_sym.to_s}_attributes" =>
      @gd_sym.to_s.classify.constantize.attr_syms_for_params }
    a = [
      :contest_nth, :region_code, :round, :game, :opponent_robot_code, :victory
    ].push(h)
    params.require(:game).permit(a)
  end

  def regularize(attrs_hash:)
    gdas = "#{@gd_sym.to_s}_attributes".to_sym
    klass = @gd_sym.to_s.singularize.classify.constantize # クラス化
    j = 1
    if not attrs_hash[gdas].blank?
      attrs_hash[gdas].each { |i|
        attrs_hash[gdas][i][:properties] =
          klass.compose_properties(hash: attrs_hash[gdas][i],
            victory: attrs_hash[:victory])
            # フォームパラメーターから GameDetail サブクラスの属性値へ合成
        attrs_hash[gdas][i][:number] = j
        j += 1
      }
    end
    attrs_hash
  end

  def game_details_sub_class_sym(contest_nth:)
    "game_detail#{contest_nth.ordinalize}s".to_sym
  end

  # def game_details_sub_class
  #   @gd_sym.to_s.singularize.classify.constantize unless @gd_sym.blank?
  # end

end
