class GamesController < ApplicationController
  before_action :logged_in_user,
    only: [ :new, :create, :edit, :update, :destroy ]

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
    @game.send(@gd_sym).new # GameDetail サブクラスのインスタンス生成
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    h = adapt(attrs_hash: game_params)
    h["robot_code"] = @robot.code.to_s
    h["code"] = Game.get_code(hash: h).to_s
    @game = Game.new(h)
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
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    if @game.update(adapt(attrs_hash: game_params)) then
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

  private
  def game_params
    h = { @gd_sym.to_s + "_attributes" =>
      @gd_sym.to_s.classify.constantize.attr_syms_for_params }
    a = [
      :contest_nth, :region_code, :round, :game, :opponent_robot_code, :victory
    ].push(h)
    params.require(:game).permit(a)
  end

  def adapt(attrs_hash:)
    gdas = "#{@gd_sym.to_s}_attributes".to_sym
    klass = @gd_sym.to_s.singularize.classify.constantize # クラス化
    attrs_hash[gdas].each { |i| attrs_hash[gdas][i][:properties] =
      klass.compose_properties(hash: attrs_hash[gdas][i]) }
      # フォームパラメーターから GameDetail サブクラスへの属性値へ合成
    attrs_hash[gdas].each { |key, value|
      attrs_hash[gdas][key] = attrs_hash[gdas][key].reject { |k, v|
        klass.additional_attr_symbols.any? { |i| i.to_s == k }
          # スーパークラスの GameDetails にないものは削除しておく
      }
    }
    attrs_hash[:game_details_attributes] = attrs_hash.delete(gdas) # 名称変更
    attrs_hash
  end

  def game_details_sub_class_sym(contest_nth:)
    "game_detail#{contest_nth.ordinalize}s".to_sym
  end

end
