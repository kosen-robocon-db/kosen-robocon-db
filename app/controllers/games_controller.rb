class GamesController < ApplicationController
  def show
    @game = Game.find_by(code: params[:code])
    region = Region.find_by(code: @game.region_code)
    @title_for_tab =
      @game.contest_nth.ordinalize + " " +
      region.name[0, 1] + " " +
      @game.round.to_s + "回戦" +
      "第" + @game.game.to_s + "試合"
    @title =
      "第" + @game.contest_nth.to_s + "回 " +
      region.name + "#{ @game.region_code >= 1 ? "地区" : "" }大会 " +
      @game.round.to_s + "回戦 " +
      "第" + @game.game.to_s + "試合"
  end
end
