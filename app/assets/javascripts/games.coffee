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

  # when jury/progress cheched/unchecked
  switch gon.contest_nth
    when 29
      $('form').on 'change', (event) ->
        if /^game_game_detail29ths_attributes_\d+_jury$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail29ths_attributes_' + i + '_jury')[0].checked
            $('.jury_votes_' + i).toggleClass('hidden')
          else
            $('.jury_votes_' + i).toggleClass('hidden')
            $('#game_game_detail29ths_attributes_' + i +
              '_my_jury_votes').val('')
            $('#game_game_detail29ths_attributes_' + i +
              '_opponent_jury_voites').val('')
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
        if /^game_game_detail30ths_attributes_\d+_jury$/.test(event.target.id)
          i = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#game_game_detail30ths_attributes_' + i + '_jury')[0].checked
            $('.jury_votes_' + i).toggleClass('hidden')
          else
            $('.jury_votes_' + i).toggleClass('hidden')
            $('#game_game_detail30ths_attributes_' + i +
              '_my_jury_votes').val('')
            $('#game_game_detail30ths_attributes_' + i +
              '_opponent_jury_votes').val('')

################################################################################

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

      # 基本設定
      ctx.lineWidth = 1
      ctx.fillStyle = 'black'
      ctx.font = "16px bold"
      ctx.textAlign = 'center'
      ctx.textBaseline = 'top'

      # 基本の座標とサイズ
      console.log("canvas width", canvas[0].width) # canvas[0].widthを利用
      console.log("canvas height", canvas[0].height) # cvanvas[0].heightを利用
      entry_attrs = { # graphic attributes
        "lineWidth" : 0.5
        "left" : 0
        "width" : 400
        "height" : 22
        "roundRadius" : 4
        "gap" : 4
        "textTopOffset" : 2
      }
      entry_attrs["totalHeight"] = entry_attrs["height"] + entry_attrs["gap"]
      entry_attrs["top"] =
        (canvas[0].height - gon.entries.length * entry_attrs["totalHeight"]) / 2
      crown_attrs = {
        "width" : 50
        "height" : 50
        "left" : canvas[0].width - 50
        "top" : ( canvas[0].height - 50 ) / 2
      }
      line_attrs = {
        "hLength" : (canvas[0].width - entry_attrs.width - crown_attrs.width) /
          gon.entries.length
      }

      # 描画デバッグのための中心線
      ctx.drawLine(0, canvas[0].height / 2, canvas[0].width - 1, canvas[0].height / 2)

      # エントリー
      for value, index in gon.entries
        ctx.lineWidth = entry_attrs.lineWidth
        ctx.drawRoundRect(
          entry_attrs.left,
          entry_attrs.top + index * entry_attrs.totalHeight,
          entry_attrs.width,
          entry_attrs.height,
          entry_attrs.roundRadius
        )
        ctx.drawText(
          "#{index} #{gon.entries[index][1]}",
          entry_attrs.left + entry_attrs.width / 2,
          entry_attrs.top + index * entry_attrs.totalHeight +
            entry_attrs.textTopOffset
        )

      # 王冠
      ctx.drawImg(
        '/assets/crown_width_50px.png',
        crown_attrs.left,
        crown_attrs.top
      )

      ctx.lineWidth = 1
      o_y = 9
      width = 75
      for vi, ii in gon.line_pairs
        continue if ii < 2
        for vj, ij in vi
          # console.log(vi, vj)
          switch ii
            when 0 # １回戦
              # console.log("１回戦")
              continue
            when 1 # ２回戦
              # console.log("２回戦")
              continue
            else   # ３回戦以降決勝まで
              # console.log("３回戦以降")
              for ik in [0, 1]
                if vj[ik] == vj[2]
                  ctx.strokeStyle = 'red'
                else
                  ctx.strokeStyle = 'black'
                o_xi = 0
                if vj[ik] < vj[1 - ik]
                  vertical = 13
                else
                  vertical = -13
                ctx.drawLine(
                  500 + width * (ii - o_xi),
                  100 + vj[ik] * 26 + o_y,
                  500 + width * (ii + 1),
                  100 + vj[ik] * 26 + o_y
                )
                ctx.drawLine(
                  500 + width * (ii + 1),
                  100 + vj[ik] * 26 + o_y,
                  500 + width * (ii + 1),
                  100 + vj[ik] * 26 + o_y + vertical
                )
                ctx.drawLine(
                  500 + width * (ii - o_xi + 1),
                  100 + vj[ik] * 26 + o_y + vertical,
                  500 + width * (ii + 2),
                  100 + vj[ik] * 26 + o_y + vertical
                ) if vj[ik] == vj[2] # 勝利チームのみ描画
