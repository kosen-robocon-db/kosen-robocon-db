class RobotsController < ApplicationController
  def show
    @robot = Robot.find_by(code: params[:code])
    @games = Game.where(team_left: params[:code]).or(Game.where(team_right: params[:code]))
  end
end
