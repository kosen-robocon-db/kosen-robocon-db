class CampusesController < ApplicationController
  def index
    @campuses = Campus.order_default.on_page(params[:page])
  end

  def show
    @campus = Campus.find_by(code: params[:code])
    @robots = @campus.robots.includes(:contest).order_default.on_page(params[:page])
    @campus_histories = CampusHistory.where(campus_code: params[:code])
    @prizes = Prize.joins(:prize_type).joins(:contest).where(campus_code: params[:code])
  end
end
