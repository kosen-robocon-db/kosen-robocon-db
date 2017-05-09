class PrizeHistoriesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @prize_history = Robot.find_by(code: params[:robot_code]).prize_histories.new
  end

  def create
    robot = Robot.find_by(code: params[:robot_code])
    history_params = prize_history_params
    history_params["contest_nth"] = robot.contest_nth.to_s
    history_params["campus_code"] = robot.campus_code.to_s
    @prize_history = robot.prize_histories.new(history_params) # where is the create helper method?
    if @prize_history.save then
      flash[:success] = "優勝／受賞歴の新規作成成功"
      redirect_to robot_url(code: robot.code)
    else
      render :new
    end
  end

  def edit
    @prize_history = PrizeHistory.find_by(id: params[:id])
  end

  def update
    @prize_history = PrizeHistory.find_by(id: params[:id])
    if @prize_history.update_attributes(prize_history_params) then
      flash[:success] = "ロボット情報（現況）の編集成功"
      redirect_to robot_url(code: @prize_history.robot.code)
    else
      render :edit
    end
  end

  def destroy
    PrizeHistory.find(params[:id]).destroy
    flash[:success] = "優勝／受賞歴の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  private
    def prize_history_params
      params.require(:prize_history).permit(:region_code, :prize_kind)
    end
end
