class RobotsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]

  def show
    @robot = Robot.find_by(code: params[:code])
    @games = Game.where(left_robot_code: params[:code]).or(Game.where(right_robot_code: params[:code]))
    @prize_histories = PrizeHistory.includes(:robot).where(robot_code: params[:code]).includes(:prize)
  end

  def edit
    @robot = Robot.find_by(code: params[:code])
  end

  def update
    @robot = Robot.find_by(code: params[:code])
    if @robot.update_attributes(robot_params) then
      flash[:success] = "ロボット情報の編集成功"
      redirect_to robot_url(code: @robot.code)
    else
      render 'edit'
    end
  end

  private
    def robot_params
      params.require(:robot).permit(:name, :kana, :team)
    end
end
