class RobotsController < ApplicationController
  def show
    @robot = Robot.find_by(code: params[:code])
    @games = Game.where(left_robot_code: params[:code]).or(Game.where(right_robot_code: params[:code]))
    @prize_histories = PrizeHistory.includes(:robot).where(robot_code: params[:code]).includes(:prize)
    if !@robot.robot_condition.blank? then
      @condition = @robot.robot_condition.fully_operational ? "動態保存" : "静態保存"
      @condition += @robot.robot_condition.memo.blank? ? "" : " " + @robot.robot_condition.memo
    else
      @condition = ""
    end
  end
end
