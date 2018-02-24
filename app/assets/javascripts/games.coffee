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

  # when jury_votes/progress cheched/unchecked
  switch gon.contest_nth
    when 29
      $('form').on 'change', (event) ->
        if /^game_game_detail29ths_attributes_\d+_jury_votes$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail29ths_attributes_' + i + '_jury_votes')[0].checked
            $('.jury_votes_' + i).toggleClass('hidden')
          else
            $('.jury_votes_' + i).toggleClass('hidden')
            $('#game_game_detail29ths_attributes_' + i +
              '_my_jury_votes').val('')
            $('#game_game_detail29ths_attributes_' + i +
              '_opponent_jury_votes').val('')
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
    when 30
      $('form').on 'change', (event) ->
        if /^game_game_detail30ths_attributes_\d+_jury_votes$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail30ths_attributes_' + i + '_jury_votes')[0].checked
            $('.jury_votes_' + i).toggleClass('hidden')
          else
            $('.jury_votes_' + i).toggleClass('hidden')
            $('#game_game_detail30ths_attributes_' + i +
              '_my_jury_votes').val('')
            $('#game_game_detail30ths_attributes_' + i +
              '_opponent_jury_votes').val('')

  # 試合(game)で地区を変更すると回戦も変化させる
  $(document).on 'change', '#game_region_code', ->
    contest_nth = $('[id=game_contest_nth]').val();
    $.ajax(
      type: 'GET'
      url: '/round_names/get'
      dataType: "json"
      data: {
        contest_nth: contest_nth,
        region_code: $(this).val()
      }
    ).done (results) ->
      i = 0 # each with indexを使うと意図したとおりに動かなかったので制御変数を使うことにした
      $.each results, ->
        option = $('<option>').val(this.round).text(this.name)
        if i == 0
          $('#game_round').html option
        else
          $('#game_round').append(option)
        i += 1
