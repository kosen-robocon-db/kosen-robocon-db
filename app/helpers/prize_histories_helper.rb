module PrizeHistoriesHelper

  def link_to_prior_prize_history(contest_nth, region_code)
    if contest_nth.to_i > 4 then # It's a hard code! But never changed.
      link_to fa_icon("chevron-left", text: "前回"),
        contest_prize_history_path(
          contest_nth: (contest_nth.to_i - 1).to_s,
          region_code: region_code
        )
    end
  end

  def link_to_posterior_prize_history(contest_nth, region_code)
    if contest_nth.to_i < 30 then # It's a hard code! Propose alternative ways!
      link_to fa_icon("chevron-right", text: "次回"),
        contest_prize_history_path(
          contest_nth: (contest_nth.to_i + 1).to_s,
          region_code: region_code
        )
    end
  end

end
