class RobotConditionsController < ApplicationController
  def edit
    @robot = Robot.find_by(code: params[:code])
  end

  def update
    @robot = Robot.find_by(code: params[:code])
    if @robot.robot_condition.update_attributes(robot_condition_params) then
      flash[:success] = "ロボット情報（現況）の編集成功"
      redirect_to robot_url(code: @robot.code)
    else
      render 'edit'
    end
  end

  private
    def robot_condition_params
      params.require(:robot_condition).permit(:fully_operational, :restoration, :memo)
    end
end
