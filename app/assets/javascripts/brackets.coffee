# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('canvas').each ->
    canvas = $('#bracket')
    # console.log("canvas", canvas)
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
      # console.log("canvas width", canvas[0].width) # canvas[0].widthを利用
      # console.log("canvas height", canvas[0].height) # cvanvas[0].heightを利用
      entry_attrs = { # graphic attributes
        "lineWidth" : 0.5
        "left" : 0
        "width" : 400
        "height" : 22
        "roundRadius" : 4
        "gap" : 4
        "textTopOffset" : 2
      }

      # 描画デバッグのための中心線
      # ctx.drawLine(0, canvas[0].height / 2, canvas[0].width - 1, canvas[0].height / 2)

      # 王冠
      crown_attrs = {
        "width" : 50
        "height" : 50
        "left" : canvas[0].width - 50
        "top" : ( canvas[0].height - 50 ) / 2
      }
      ctx.drawImg(
        '/assets/crown_width_50px.png',
        crown_attrs.left,
        crown_attrs.top
      )
