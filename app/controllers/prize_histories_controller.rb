class PrizeHistoriesController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: :index

  def show
    @region = Region.find_by("code = ?", params[:region_code])
    @tournament = @region.code == 0 ?
      "#{@region.name}大会" : "#{@region.name}地区大会"
    @results = PrizeHistory.where(
      "contest_nth = ? and region_code = ? and prize_kind <= 4",
      params[:contest_nth], params[:region_code]
    ).order("prize_kind asc")
    @prizes  = PrizeHistory.where(
      "contest_nth = ? and region_code = ? and prize_kind >  4",
      params[:contest_nth], params[:region_code]
    ).order("prize_kind asc")
    if params[:region_code] != "0" then
      @advancement_histories = AdvancementHistory.where(
        "contest_nth = ? and region_code = ?",
        params[:contest_nth], params[:region_code]
      ).order("advancement_case asc")
    else
      @advancement_histories = AdvancementHistory.where(
        "contest_nth = ?",
        params[:contest_nth]
      ).order("campus_code asc")
    end
  end

  def new
    robot = Robot.find_by(code: params[:robot_code])
    @prize_history = robot.prize_histories.new
    @regions = Region.where(code: [ 0, robot.campus.region_code ])
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
    robot = Robot.find_by(code: params[:robot_code])
    @prize_history = PrizeHistory.find_by(id: params[:id])
    @regions = Region.where(code: [ 0, robot.campus.region_code ])
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
