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
    @game.send(@gd_sym).new # GameDetail サブクラスのインスタンス生成（表示される）
    gon.contest_nth = @robot.contest_nth
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    h = regularize(attrs_hash: game_params)
    h["robot_code"] = @robot.code.to_s
    h["code"] = Game.get_code(hash: h).to_s
    @game = Game.new(h)
    if @game.save then
      flash[:success] = "試合情報の新規作成成功"
      redirect_to robot_url(params[:robot_code])
    else
      @game.errors.details[:code].each do |code|
        if code[:error] == :taken then
          h.delete("code") # コードの指定を無くすことでDBから読み込まなくなる
          prepare_game_object_on_code_error(hash: h, code: code[:value])
        end
      end
      render :new and return
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
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    h = regularize(attrs_hash: game_params)
    h["robot_code"] = @robot.code.to_s # これ必要？
    if
      @game.region_code.to_i != h['region_code'].to_i or
      @game.round.to_i != h['round'].to_i or
      @game.game.to_i != h['game'].to_i
    then # game_code の変更がある場合
      code = h["code"] = Game.get_code(hash: h).to_s
      if Game.exists?(code: h["code"]) then
        h["code"] = params[:code] # コードを戻す
        prepare_game_object_on_code_error(hash: h, code: code)
        @next_request_method = "PATCH"
        render :edit and return
      else # DB に変更したい game_code を持つレコードが存在しなかったので新規作成
        gdas = "#{@gd_sym.to_s}_attributes".to_sym
        h[gdas].each{ |i| h[gdas][i][:id] = nil } # 新レコード登録を強制
        old_game_code = @game.code
        @game = Game.new(h)
        if @game.save then
          Game.find_by(code: old_game_code).destroy
          flash[:success] = "試合情報の編集成功"
          redirect_to robot_url(code: params[:robot_code])
        else # 試合コードが既存であること以外でエラー
          @next_request_method = "PATCH"
          render :edit and return
        end
      end
    else # game_code の変更がない場合
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
    klass = @gd_sym.to_s.singularize.classify.constantize # シムからクラス化
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

  # フォーム項目の並び順にエラーを出力したいが、後日改良する。
  # コメントアウトされているのは後日改良のためのコード。
  def prepare_game_object_on_code_error(hash:, code:)
    @game = Game.new(hash)
    @game.valid?
    # errors = @game.errors.dup
    # @game.errors.clear
    @game.errors.delete(:code)
    robot_code = Game.find_by(code: code).left_robot_code
    path = robot_game_path(robot_code: robot_code, code: code)
    m = I18n.t("errors.messages.taken")
    n = I18n.t("activerecord.errors.models.game.attributes.code.duplicated")
    m << "（#{view_context.link_to n, path}）"
    @game.errors.add(:code, m)
    %i( region_code round game ).each { |sym| @game.errors.add(sym, "")}
    # @game.errors.merge!(errors)
  end

end
