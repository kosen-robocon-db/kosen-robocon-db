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

  def edit
    @robot = Robot.find_by(code: params[:code])
  end

  def update
    #@robot = Robot.find_by(code: params[:code])
    @robot = Robot.find_by(id: params[:code])
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
