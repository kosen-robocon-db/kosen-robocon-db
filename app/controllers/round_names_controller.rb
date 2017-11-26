class RoundNamesController < ApplicationController
  def get
    # ajax によるリクエストの場合のみ処理
    if request.xhr?
      if params[:contest_nth].present? && params[:region_code].present?
        round_names = RoundName.where(
          contest_nth: params[:contest_nth],
          region_code: params[:region_code]
        )
        render json: round_names.select(:round, :name).as_json(except: :id)
      end
    end
  end
end
