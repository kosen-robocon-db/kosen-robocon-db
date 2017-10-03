class RobotsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: :index

  def show
    @robot = Robot.find_by(code: params[:code])
    @games = Game.where(left_robot_code: params[:code]).or(
      Game.where(right_robot_code: params[:code])).order("games.code ASC")
    @prize_histories = PrizeHistory.includes(:robot).where(
      robot_code: params[:code]).includes(:prize).order_default
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

  def index
    @robots = Robot.all
    respond_to do |format|
      format.csv { send_data @robots.to_csv(
        :only => Robot.csv_column_syms,
        :header => true,
        :header_columns => Robot.csv_headers,
        :force_quotes => true
      ) }
    end
  end

  private
  def robot_params
    params.require(:robot).permit(:name, :kana, :team)
  end
end
