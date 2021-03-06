class CampusesController < ApplicationController
  def index
    @campuses = Campus.without_no_campus.order_default.on_page(params[:page])
  end

  def show
    @campus = Campus.find_by(code: params[:code])
    @robots =
      @campus.robots.includes(:contest).order_default.on_page(params[:page])
    @campus_histories = CampusHistory.where(campus_code: params[:code])
    @prize_histories =
      PrizeHistory.includes(:contest).where(campus_code: params[:code]
        ).includes(:prize).order_default
    @advancement_histories = AdvancementHistory.includes(:contest).where(
      campus_code: params[:code]).includes(:advancement).order_default
  end
end
