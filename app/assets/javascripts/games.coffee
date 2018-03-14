$ ->
  controller = $('body').data('controller')
  action     = $('body').data('action')
  return if controller != "Games" || ( action != "new" && action != "edit" )
    # Gamesコントローラーのnewまたはecitアクション以外は次からを実行させない
    # ページ遷移時に必要なスクリプトファイルだけ読み込ませればよいが
    # 読み込ませなくすればよいが今回はこの形式を採用

  ##############################################################################

  # Numberオブジェクトに序数メソッドを追加
  Number::ordinal = ->
    return 'th' if 11 <= this % 100 <= 13
    switch this % 10
      when 1 then 'st'
      when 2 then 'nd'
      when 3 then 'rd'
      else        'th'

  Number::ordinalize = ->
    this + this.ordinal()

  ##############################################################################

  # 表示／非表示が切り替えられる対戦チーム同士の属性のためのクラス
  class GameDetailAttributes

    constructor: (args) ->
      return unless args.nth or args.attributes
      @nth = args.nth ? 0
      @attributes = args.attributes
      @prefix = 'game_game_detail' +
        parseInt(@nth).ordinalize() + 's' +
        '_attributes_'
      @regexs = (///^#{@prefix}\d_#{i}$/// for i in @attributes)

    # public methods
    switch: (event) ->
      return if @nth = 0
      for regex, i in @regexs
        if regex.test(event.target.id)
          j = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
          if $('#' + @prefix + j + '_' + @attributes[i])[0].checked
            $('.' + @attributes[i] + '_' + j).toggleClass('hidden')
          else
            $('.' + @attributes[i] + '_' + j).toggleClass('hidden')
            $('#' + @prefix + j + '_my_' + @attributes[i]).val('')
            $('#' + @prefix + j + '_opponent_' + @attributes[i]).val('')

  ##############################################################################

  # GameDetailAttributesクラスのオブジェクト生成用データ
  # モデルでスイッチ表示する属性情報を持たせようと思ったがここで持たせることにした
  switching_attributes = {
    13: [ 'jury_votes' ]
    14: [ 'jury_votes' ]
    15: [ 'jury_votes' ]
    29: [ 'jury_votes', 'progress' ]
    30: [ 'jury_votes' ]
  }

  ##############################################################################

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

  ##############################################################################

  # 試合詳細の「再試合」ラベル表示
  c = 0
  $('div.replay').each ->
    c += 1
    replay_label c, $(@)

  # 表示／非表示が切り替えられる対戦チーム同士の属性を調べるためのオブジェクトを生成
  # switching_attributesに登録されてなければスルー
  if gon.contest_nth  && gon.contest_nth of switching_attributes
    gda = new GameDetailAttributes({
      nth: gon.contest_nth,
      attributes: switching_attributes[gon.contest_nth]
    })

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
      i = 0
        # each with indexを使うと意図したとおりに動かなかったので
        # 制御変数を使うことにした
      $.each results, ->
        option = $('<option>').val(this.round).text(this.name)
        if i == 0
          $('#game_round').html option
        else
          $('#game_round').append(option)
        i += 1

  # when game_detail added
  $('form').on 'fields_added.nested_form_fields', (event, param) ->
    replay_labels()

  # when game_detail removed
  $('form').on 'fields_removed.nested_form_fields', (event, param) ->
    replay_labels()

  # フォームの変更があれば、
  # 表示／非表示が切り替えられる対戦チーム同士の属性のチェックボックス変更の調査、
  # 変更された場合の処理をGameDetailAttributesのオブジェクトに任せる
  $('form').on 'change', (event) ->
    if gda
      gda.switch(event)
