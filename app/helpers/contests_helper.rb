module ContestsHelper

  def link_to_prior_contest(contest_nth)
    if contest_nth.to_i > 1 then # It's a hard code! But never changed.
      link_to fa_icon("chevron-left", text: "前回"),
        contest_path(
          nth: (contest_nth.to_i - 1).to_s
        )
    end
  end

  def link_to_posterior_contest(contest_nth)
    if contest_nth.to_i < 30 then # It's a hard code! Propose alternative ways!
      link_to fa_icon("chevron-right", text: "次回"),
        contest_path(
          nth: (contest_nth.to_i + 1).to_s
        )
    end
  end

end
