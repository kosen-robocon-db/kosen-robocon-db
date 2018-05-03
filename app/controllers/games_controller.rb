class GamesController < ApplicationController

  before_action :logged_in_user,
    only: [ :new, :create, :edit, :update, :destroy ]
  before_action :admin_user, only: :index

  def index
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @games = Game.where(left_robot_code: @robot.code).\
      or(Game.where(right_robot_code: @robot.code))
  end

  def show
    # 試合コードは"1300901"のような1で始まり、2-3桁目が大会回数となっているが、
    # 疑いもなく、エラー処理もRailsデフォルト任せにしておく。（暫定）
    @gd_sym = game_details_sub_class_sym(contest_nth: params[:code][1, 2].to_i)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.subjective_view_by(robot_code: @game.left_robot_code)
    @game.send(@gd_sym).each do |i|
      i.decompose_properties(robot: @game.left_robot)
    end
  end

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
    # case @robot.contest_nth
    # when 1..20,29,30 then
      @game.send(@gd_sym).new # GameDetail サブクラスのインスタンス生成
    # end
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: 0)
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
      error_with_code?(code: h["code"])
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
    @game.send(@gd_sym).each { |i| i.decompose_properties(robot: @robot) }
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
    # 下記のifから下のupdateの終わりまでのコードはもっと洗練されるべき
    if
      @game.region_code.to_i != h['region_code'].to_i or
      @game.round.to_i != h['round'].to_i or
      @game.game.to_i != h['game'].to_i
    then
      # game_code の変更がある場合
      h["robot_code"] = @robot.code.to_s
      h["code"] = Game.get_code(hash: h).to_s
      gdas = "#{@gd_sym.to_s}_attributes".to_sym
      h[gdas].each{ |i| # id を nil にしないと新しいレコードが登録されない
        h[gdas][i][:id] = nil
      }
      # Game オブジェクトを作成前に既存レコードが DB に存在しているか調べておく
      if Game.exists?(code: h["code"]) then
        # game_code を変更したいが、既に同じコードのレコードがあったので、
        # game_code のエラーだけを表示させて、:edit をレンダリングさせる。
        # フォームに入力した値は変更前に戻すことにした（暫定）
        # 将来もっと良い方法があればそちらに切り替える。
        @game = Game.find_by(code: params[:code])
        @game.subjective_view_by(robot_code: @robot.code)
        @game.send(@gd_sym).each { |i| i.decompose_properties(robot: @robot) }
        @game.errors.add(:code, code_error_message(code: h[:code]))
        render :edit and return
      else
        # DB に変更したい game_code のレコードが存在しなかったので新規作成
        old_game_code = @game.code
        @game = Game.new(h)
        if @game.save then
          Game.find_by(code: old_game_code).destroy
          flash[:success] = "試合情報の編集成功"
          redirect_to robot_url(code: params[:robot_code])
        else
          # (game)コード以外でエラーになった場合
          # new で新しい Game オブジェクトを作成したので、
          # つまり new_record? / persisted? のフラグ状態が新規作成なので
          # 更新と扱われないため、リクエストメソッドを強制的に PATCH にする。
          # 因みに、ブラウザが GET と POST しか扱わないため、Rails では
          # hidden 指定されている _method にリクエストメソッドを指定している。
          @next_request_method = "PATCH"
          render :edit and return
        end
      end
    else
      # game_code の変更がない場合
      if @game.update(h) then
        flash[:success] = "試合情報の編集成功"
        redirect_to robot_url(code: params[:robot_code])
      else
        render :edit and return
      end
    end

  end

  def destroy
    Game.find_by(code: params[:code]).destroy
    flash[:success] = "試合情報の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  private

  def game_params
    a = %i( contest_nth region_code round game opponent_robot_code victory )
    r = { :reasons_for_victory => [] }
    h = { "#{@gd_sym.to_s}_attributes" =>
      @gd_sym.to_s.classify.constantize.attr_syms_for_params }
    params.require(:game).permit(a.push(r).push(h))
  end

  def regularize(attrs_hash:)
    gdas = "#{@gd_sym.to_s}_attributes".to_sym
    klass = @gd_sym.to_s.singularize.classify.constantize # クラス化
    j = 1
    if not attrs_hash[gdas].blank?
      attrs_hash[gdas].each { |i|
        attrs_hash[gdas][i][:my_robot_code]  = @robot.code.to_s
        attrs_hash[gdas][i][:opponent_robot_code] =
          attrs_hash[:opponent_robot_code]
        attrs_hash[gdas][i][:victory] = attrs_hash[:victory]
        attrs_hash[gdas][i][:properties] =
          klass.compose_properties(hash: attrs_hash[gdas][i]).to_json
            # フォームパラメーターから GameDetail サブクラスの properties を合成
            # before...でできないのかな？
        attrs_hash[gdas][i][:number] = j
        j += 1
      }
    end
    attrs_hash
  end

  def game_details_sub_class_sym(contest_nth:)
    "game_detail#{contest_nth.ordinalize}s".to_sym
  end

  # エラーメッセージはこのコントローラーに埋め込むことなくconfig/*/*.ymlなどに
  # 記したメッセージを使うようにしたい。
  def code_error_message(code:)
    m =  "は既に登録されています。"
    m << "（#{
      view_context.link_to "該当試合",
        robot_game_path(
          robot_code: @game.left_robot_code,
          code: code
        )
    }）"
    m << "<p>フォームの値は変更前に戻されています。<br />"
    m << "試合コードと試合詳細を変更したいときは"
    m << "先に試合コードの衝突を解決してください。<p>"
  end

end
