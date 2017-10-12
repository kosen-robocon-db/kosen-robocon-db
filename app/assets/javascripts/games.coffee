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

  $('canvas').each ->
    canvas = $('#draw_bracket')
    if canvas
      ctx = canvas[0].getContext('2d')

      ctx.putPoint = (x, y, r)-> # x,yに点を描画
        @.beginPath()
        @.arc(x, y, @.lineWidth * r, 0, Math.PI*2, false)
        @.closePath()
        @.fill()

      ctx.drawLine = (sx, sy, ex, ey)-> # 始点(sx, sy) から 終点(ex, ey)に線を描画
        @.beginPath()
        @.moveTo(sx, sy)
        @.lineTo(ex, ey)
        @.closePath()
        @.stroke()

      ctx.drawText = (t, x, y)->
        @.beginPath()
        @.closePath();
        @.fillText(t, x, y)

      ctx.drawRect = (x, y, w, h)->
        @.beginPath();
        @.rect(x, y, w, h)
        @.closePath();
        @.stroke()

      ctx.drawImg = (url, x, y)->
        @.beginPath();
        img = new Image()
        img.onload = ->
          ctx.drawImage(img, x, y)
        img.src = url
        @.closePath();
        @.stroke

      ctx.drawRoundRect = (x, y, w, h, r)->
        if w < 2 * r
          r = w / 2
        if h < 2 * r
          r = h / 2
        @.beginPath();
        @.moveTo(x+r, y)
        @.arcTo(x+w, y,   x+w, y+h, r)
        @.arcTo(x+w, y+h, x,   y+h, r)
        @.arcTo(x,   y+h, x,   y,   r)
        @.arcTo(x,   y,   x+w, y,   r)
        @.closePath();
        @.stroke()

      # ctx.fillStyle = 'white'
      # ctx.fillRect(0, 0, 1000, 750) # 背景を白に
      # ctx.putPoint(500, 500)
      # ctx.drawLine(100, 50, 900, 700)
      # ctx.drawText("ほげ", 700, 400)
      # ctx.drawRect(500, 100, 100, 200)
      # ctx.drawImg('http://yoppa.org/works/cuc/html5_logo.png', 0, 0)
      ctx.lineWidth = 1
      ctx.fillStyle = 'black'
      ctx.font = "16px bold"
      ctx.textAlign = 'center'
      ctx.textBaseline = 'top'
      # for value, index in gon.robots
      for value, index in gon.entries
        ctx.lineWidth = 0.5
        ctx.drawRoundRect(100, 100 + index * 26 - 2, 400, 22, 4)
        # ctx.drawText(gon.campuses[index].abbreviation + value.team + ' ' + value.name,
        ctx.drawText(gon.entries[index][1],
          300, 100 + index * 26)
      ctx.drawImg('/assets/crown_width_50px.png', 950, 325)
      ctx.lineWidth = 1
      o_y = 9
      width = 75
      for vi, ii in gon.lines
        # break if ii > 1
        for vj, ij in vi
          if ii > 0 and gon.lines[ii - 1][ij] == 2
            o_xi = 1
          else
            o_xi = 0
          switch vj
            when 0
              ctx.strokeStyle = 'black'
              ctx.drawLine(500 + width * (ii - o_xi), 100 + (ij) * 26 + o_y, 500 + width * (ii + 1), 100 + (ij) * 26 + o_y)
            when 1
              ctx.strokeStyle = 'red'
              ctx.drawLine(500 + width * (ii - o_xi), 100 + (ij) * 26 + o_y, 500 + width * (ii + 1), 100 + (ij) * 26 + o_y)
            else
