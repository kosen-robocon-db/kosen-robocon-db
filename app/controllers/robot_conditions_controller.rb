class RobotConditionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @robot = Robot.find_by(code: params[:robot_code])
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    if @robot.create_robot_condition(robot_condition_params) then
      flash[:success] = "ロボット情報（現況）の新規作成（現存記録）成功"
      redirect_to robot_url(code: @robot.code)
    else
      render :new
    end
  end

  def edit
    @robot = Robot.find_by(code: params[:robot_code])
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    if @robot.robot_condition.update_attributes(robot_condition_params) then
      flash[:success] = "ロボット情報（現況）の編集成功"
      redirect_to robot_url(code: @robot.code)
    else
      render :edit
    end
  end

  def destroy
    @robot = Robot.find_by(code: params[:robot_code])
    @robot.robot_condition.destroy
    redirect_to robot_path(code: @robot.code)
  end

  private
    def robot_condition_params
      params.require(:robot_condition).permit(:fully_operational, :restoration, :memo)
    end
end
