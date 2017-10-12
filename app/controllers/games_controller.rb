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
    case @robot.contest_nth
      # GameDetail サブクラスのインスタンス生成
    when 29 then
      @game.send(@gd_sym).new(judge: false, progress: false)
        # 審査員判定および課題進捗度チェックボックスを外しておく
        # 将来的にモデル内で処理
    end
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
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
    @game.send(@gd_sym).each { |i| i.decompose_properties }
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    if @game.update(regularize(attrs_hash: game_params)) then
      flash[:success] = "試合情報の編集成功"
      redirect_to robot_url(code: params[:robot_code])
    else
      render :edit
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
      format.csv { send_data @games.to_a.to_csv(
        :only => Game.csv_column_syms,
        :header => true,
        :header_columns => Game.csv_headers
      ) }
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
    # bracket.lines
    gon.lines = [ # 0:負け 1:勝ち 2:スルー 3:データなし
      [ # １回戦
        2, 2, 2, 1, 0, 2, 2, 2, 1, 0, 2, 2, 2, 1, 0, 2, 2, 2, 1, 0
      ],
      [ # ２回戦
        0, 1, 0, 1, 3, 1, 0, 1, 0, 3, 1, 0, 0, 1, 3, 1, 0, 1, 0, 3
      ],
      [ # ３回戦
        3, 0, 3, 1, 3, 0, 3, 1, 3, 3, 1, 3, 3, 0, 3, 1, 3, 0, 3, 3
      ],
      [ # 準決勝
        3, 3, 3, 1, 3, 3, 3, 0, 3, 3, 1, 3, 3, 3, 3, 0, 3, 3, 3, 3
      ],
      [ # 決勝
        3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3
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
          klass.compose_properties(hash: attrs_hash[gdas][i])
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
