$ ->
  # write/rewrite for a label
  replay_label = (counter, element) ->
    switch counter
      when 1
        element.text ''
      else
        element.text '再' + '々'.repeat(counter - 2) + '試合'

  # write/rewrite for all labels
  replay_labels = ->
    c = 0
    $('.nested_fields').each ->
      if $(@).css('display') != 'none'
        c += 1
        replay_label c, $(@).children('div.enclosure').children('div.replay')

  # run on load
  c = 0
  $('div.replay').each ->
    c += 1
    replay_label c, $(@)

  # when game_detail added
  $('form').on 'fields_added.nested_form_fields', (event, param) ->
    replay_labels()

  # when game_detail removed
  $('form').on 'fields_removed.nested_form_fields', (event, param) ->
    replay_labels()

  # when judge/progress cheched/unchecked
  switch gon.contest_nth
    when 29
      $('form').on 'change', (event) ->
        if /^game_game_detail29ths_attributes_\d+_judge$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail29ths_attributes_' + i + '_judge')[0].checked
            $('.judge_score_' + i).toggleClass('hidden')
          else
            $('.judge_score_' + i).toggleClass('hidden')
            $('#game_game_detail29ths_attributes_' + i +
              '_judge_to_me').val('')
            $('#game_game_detail29ths_attributes_' + i +
              '_judge_to_opponent').val('')
        if /^game_game_detail29ths_attributes_\d+_progress$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail29ths_attributes_' + i + '_progress')[0].checked
            $('.progress_' + i).toggleClass('hidden')
          else
            $('.progress_' + i).toggleClass('hidden')
            $('#game_game_detail29ths_attributes_' + i +
              '_my_progress').val('')
            $('#game_game_detail29ths_attributes_' + i +
              '_opponent_progress').val('')
