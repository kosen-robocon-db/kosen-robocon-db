class GameDetailsController < ApplicationController
  def index
    @game_details = GameDetail.all
    respond_to do |format|
      format.json do
        send_data render_to_string, filename: "game_details.json", type: :json
      end
      format.csv do
        @game_details.each { |i| i.properties.gsub!( /\{|\}|"/, "" ) }
        send_data @game_details.to_a.to_csv(
          :only => GameDetail.csv_column_syms,
          :header => true,
          :header_columns => GameDetail.csv_headers
        )
      end
    end
  end
end
