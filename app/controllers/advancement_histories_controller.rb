class AdvancementHistoriesController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  # before_action :admin_user, only: :index
  before_action :set_robot, only: [:new, :create, :edit, :update, :destroy]

  def new
  end

  def create
    params = advancement_history_params
    params["contest_nth"] = @robot.contest_nth
    params["region_code"] = @robot.campus.region_code
    params["campus_code"] = @robot.campus.code
    if @robot.create_advancement_history(params) then
      flash[:success] = "全国大会進出情報の新規作成成功"
      redirect_to robot_url(code: @robot.code)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @robot.advancement_history.update_attributes(advancement_history_params)
    then
      flash[:success] = "全国大会進出情報の編集成功"
      redirect_to robot_url(code: @robot.code)
    else
      render :edit
    end
  end

  def destroy
    @robot.advancement_history.destroy
    redirect_to robot_path(code: @robot.code)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_robot
    @robot = Robot.find_by(code: params[:robot_code])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def advancement_history_params
    params.require(:advancement_history).permit(
      :robot_code, :advancement_case, :decline, :memo
    )
  end

end
