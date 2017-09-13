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

  # when judge cheched/unchecked
  $('#game_game_detail29ths_attributes_0_judge').change ->
    if $('#game_game_detail29ths_attributes_0_judge')[0].checked
      $('.judge_score_0').toggleClass('hidden')
    else
      $('.judge_score_0').toggleClass('hidden')
      $('#game_game_detail29ths_attributes_0_judge_to_me').val('')
      $('#game_game_detail29ths_attributes_0_judge_to_opponent').val('')
