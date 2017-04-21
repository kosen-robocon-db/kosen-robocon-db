class GamesController < ApplicationController
  def show
    @game = Game.find_by(code: params[:code])
  end
end
