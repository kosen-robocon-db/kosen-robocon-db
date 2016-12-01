class ContestsController < ApplicationController
  def index
    @contests = Contest.order_default.on_page(params[:page])
  end

  def show
    @contest = Contest.find(params[:id])
    @robots = @contest.robots.includes(:campus).order_default.on_page(params[:page])
  end
end
