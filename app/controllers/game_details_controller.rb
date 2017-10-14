class GameDetailsController < ApplicationController
  def index
    @game_details = GameDetail.all
    respond_to do |format|
      format.json do
        send_data render_to_string, filename: "game_details.json", type: :json
      end
      format.csv do
        @game_details.each { |i| i.properties.gsub!( /\"/, "\"\"" ) }
        send_data @game_details.to_csv
      end
    end
  end
end
