class ContestEntriesController < ApplicationController
  def index
    @contest_entries = ContestEntry.joins(:contest).order_default.on_page(params[:page])
  end

  def show
    #@contest_entries = ContestEntry.find(params[:id])
    #@robots = @contest.robots.includes(:campus).order_default.on_page(params[:page])
  end
end
