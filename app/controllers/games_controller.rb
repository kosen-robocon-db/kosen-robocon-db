class GamesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def show
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
        # 直上のコードは短くならないかな？
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    region = Region.find_by(code: @game.region_code)
    @title_for_tab =
      @game.contest_nth.ordinalize + " " +
      region.name[0, 1] + " " +
      @game.round.to_s + "回戦" +
      "第" + @game.game.to_s + "試合"
    @title =
      "第" + @game.contest_nth.to_s + "回 " +
      region.name + "#{ @game.region_code >= 1 ? "地区" : "" }大会 " +
      @game.round.to_s + "回戦 " +
      "第" + @game.game.to_s + "試合"
      # 上記はヘルパーメソッドに移したほうがよい
  end

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
        # 直上のコードは短くならないかな？
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    h = game_params
    h.store("robot_code", @robot.code)
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
        # 直上のコードは短くならないかな？
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    @game.opponent_robot_code = @game.robot_code == @game.left_robot_code ?
      @game.right_robot_code : @game.left_robot_code
    @game.victory = @game.robot_code == @game.winner_robot_code ? "true" : "false"
    logger.debug(@game.to_yaml)
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
      # def直下から上記までのコードを洗練させるべき。
      # でもrobot_codeをfind_by実行前後でどうやってもたせる？
    if @game.update(game_params) then
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
      params.require(:game).permit(
        :contest_nth, :region_code, :round, :game, :opponent_robot_code, :victory
      )
    end
end
