class BracketsController < ApplicationController
  def show
    @contest = Contest.find_by(nth: params[:contest_nth])
    @region = Region.find_by("code = ?", params[:region_code])
  end
end
