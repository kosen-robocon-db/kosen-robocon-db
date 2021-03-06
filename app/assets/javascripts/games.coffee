$ ->
  controller = $('body').data('controller')
  action     = $('body').data('action')
  return if controller != "Games" ||
    ( action != "new" && action != "edit" && action != "show" )
    # Gamesコントローラーのnewまたはeditアクション以外は次からを実行させない。
    # ページ遷移時に必要なスクリプトファイルだけ読み込ませればよいが、
    # 今回はこの形式を採用。
    # 再試合・再々試合などの表示のためにshowを追加した。

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
     7: [ 'special_win' ]
     8: [ 'special_win' ]
     9: [ 'special_win' ]
    12: [ 'special_win' ]
    13: [ 'special_win', 'jury_votes' ]
    14: [ 'jury_votes' ]
    15: [ 'special_win', 'jury_votes' ]
    16: [ 'jury_votes' ]
    17: [ 'jury_votes' ]
    18: [ 'progress', 'distance', 'jury_votes' ]
    19: [ 'progress', 'special_win', 'jury_votes' ]
    20: [ 'special_win', 'jury_votes' ]
    21: [ 'progress', 'jury_votes' ]
    22: [ 'jury_votes' ]
    23: [ 'jury_votes' ]
    24: [ 'jury_votes' ]
    25: [ 'my_special_win', 'opponent_special_win', 'jury_votes' ]
    26: [ 'jury_votes' ]
    27: [ 'jury_votes' ]
    28: [ 'my_special_win', 'opponent_special_win', 'jury_votes' ]
    29: [ 'progress', 'jury_votes' ]
    30: [ 'jury_votes' ]
    31: [ 'special_win', 'jury_votes' ]
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

  # 第31回大会専用関数

  # リーグセレクターの切り替え表示　リーグ戦は地区大会のみ実施
  league_toggle_by = (region_code) -> 
    switch Number(region_code)
      when 0                      # 全国
        $('#game_league').hide();
      when 1, 2, 3, 4, 5, 6, 7, 8 # 地区
        $('#game_league').show();
      else

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

  # 第31回大会の場合
  contest_nth = $('[id=game_contest_nth]').val();
  switch Number(contest_nth)
    when 31
      region_code = $('[id=game_region_code]').val();
      league_toggle_by(region_code)
    else

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
    # 第31大会の予選リーグ項目の表示切替
    switch Number(contest_nth)
      when 31
        region_code = $('[id=game_region_code]').val();
        league_toggle_by(region_code)
      else
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

  # 第24回大会で先行のチェックボックスを自他排他制御
  $(document).on 'change', (event, param) ->
    regex = ///^game_game_detail24ths_attributes_\d_(my|opponent)_play_first$///
    if regex.test(event.target.id)
      number = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
      distinction = event.target.id.match(
        /_(my|opponent)_/)[0].replace(/_/g, ''
      )
      switch distinction
        when "my"
          opposite = "opponent"
        when "opponent"
          opposite = "my"
        else
          opposite = "my"
      $('#game_game_detail24ths_attributes_' + number + '_' + opposite +
        '_play_first').prop('checked', !event.target.checked)

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

    # 第31回大会で得点を自動計算
  $(document).on 'change', (event, param) ->
    header = "game_game_detail31sts_attributes"
    regex = ///^#{header}_\d_(my|opponent)_///
    if regex.test(event.target.id)
      number = event.target.id.match(/_\d+_/)[0].replace(/_/g, '')
      distinction = 
        event.target.id.match(/_(my|opponent)_/)[0].replace(/_/g, '')
      # 四つのフィールド個別にイテーレーションで処理してもよいが、
      # 恐らくこのままの方が速いだろう。
      target_fields = event.target.id.match(
        /(fixed_table[1-3]|double_table_upper|double_table_lower|movable_table[1-3])$/)
      prefix = '#'+header+"_"+number+"_"+distinction + "_"
      if target_fields
        count = []
        # 固定テーブルに何本立てても1テーブルにつき1点
        for i in [1..3]
          if Number($(prefix + "fixed_table" + String(i)).val()) 
            count.push(1)
          else 
            count.push(0)
        count.push(Number($(prefix + "double_table_upper").val()) || 0)
        count.push(Number($(prefix + "double_table_lower").val()) || 0)
        count.push(Number($(prefix + "movable_table1").val()) || 0)
        count.push(Number($(prefix + "movable_table2").val()) || 0)
        count.push(Number($(prefix + "movable_table3").val()) || 0)
        point  = count[0] + count[1] + count[2]
        point += count[3] * 5 + count[4]
        point += count[5] + count[6] + count[7]
        $(prefix + "point").val(point)
      