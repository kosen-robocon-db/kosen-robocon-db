class RobotsController < ApplicationController
  def show
    @robot = Robot.find_by(code: params[:code])
    @games = Game.where(left_robot_code: params[:code]).or(Game.where(right_robot_code: params[:code]))
    @prize_histories = PrizeHistory.includes(:robot).where(robot_code: params[:code]).includes(:prize)
  end
end
