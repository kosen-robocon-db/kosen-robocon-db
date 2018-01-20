class ContestsController < ApplicationController
  def index
    @contests = Contest.without_no_contest.order_default.on_page(params[:page])
  end

  def show
    @contest = Contest.find_by(nth: params[:nth])
    @robots = @contest.robots.includes(:campus).order_default.on_page(params[:page])
    @regions = Region.where("code <= 8")
  end
end
