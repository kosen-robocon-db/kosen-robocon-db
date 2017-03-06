class RobotsController < ApplicationController
  def show
    @robot = Robot.find_by(code: params[:code])
  end
end
