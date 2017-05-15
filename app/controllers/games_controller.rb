class GamesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def show
    @game = Game.find_by(code: params[:code])
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
    @game_form = GameForm.new(contest_nth: @robot.contest_nth)
    @game_form.persisted = false
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    @game_form = GameForm.new(game_form_params) # エラー時の再描画の為に必要
    gp = game_form_params
    gp["code"] = Game.make_game_code(
      params[:game_form][:contest_nth], params[:game_form][:region_code],
      params[:game_form][:round], params[:game_form][:game])
    gp["left_robot_code"] = params[:robot_code]
    gp["right_robot_code"] = params[:game_form][:opponent_robot_code]
    gp["winner_robot_code"] =
      params[:game_form][:victory] == "true" ?
        params[:robot_code] : params[:game_form][:opponent_robot_code]
          # to_binaryが無いためこのようなコードになった。
    gp.delete("opponent_robot_code")
    gp.delete("victory")
    logger.debug(gp.to_yaml)
    if Game.create(gp) then
      flash[:success] = "試合情報の新規作成成功"
      redirect_to robot_url(params[:robot_code])
    else
      render :new
      #redirect_to new_robot_game_path(params[:robot_code])
    end
  end

  def edit
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    game = Game.find_by(code: params[:code])
    opponent_robot_code = @robot.code == game.left_robot_code ?
      game.right_robot_code : game.left_robot_code
    victory = @robot.code == game.winner_robot_code ? "true" : "false"
    @game_form = GameForm.new(
      contest_nth:         game.contest_nth,
      region_code:         game.region_code,
      round:               game.round,
      game:                game.game,
      opponent_robot_code: opponent_robot_code,
      victory:             victory,
      persisted:           true
    )
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @game_form = GameForm.new(game_form_params) # エラー時の再描画の為に必要
    gp = game_form_params
    gp["code"] = Game.make_game_code(
      params[:game_form][:contest_nth], params[:game_form][:region_code],
      params[:game_form][:round], params[:game_form][:game])
    gp["left_robot_code"] = params[:robot_code]
    gp["right_robot_code"] = params[:game_form][:opponent_robot_code]
    gp["winner_robot_code"] =
      params[:game_form][:victory] == "true" ?
        params[:robot_code] : params[:game_form][:opponent_robot_code]
          # to_binaryが無いためこのようなコードになった。
    gp.delete("opponent_robot_code")
    gp.delete("victory")
    logger.debug(gp.to_yaml)
    game = Game.find_by(code: params[:code])
    if game.update_attributes(gp) then
      flash[:success] = "試合情報の編集成功"
      redirect_to robot_url(code: params[:robot_code])
    else
      render :edit
      #redirect_to edit_robot_game_path(robot_code: params[:robot_code],
      #  code: params[:code])
    end
  end

  def destroy
    #@robot = Robot.find_by(code: params[:robot_code])
    Game.find_by(code: params[:code]).destroy
    flash[:success] = "試合情報の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  private
    def game_form_params
      params.require(:game_form).permit(:contest_nth, :region_code, :round,
        :game, :opponent_robot_code, :victory)
    end
end
