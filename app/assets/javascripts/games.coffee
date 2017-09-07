# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# $(document).on('ready page:load', function () {
#   alert("テストだよ！")
# });

# $ ->
#   $('form').on 'click', '.remove_fields', (event) ->
#     $(this).prev('input[type=hidden]').val('1')
#     $(this).closest('fieldset').hide()
#     event.preventDefault()
#
#   $('form').on 'click', '.add_fields', (event) ->
#     time = new Date().getTime()s
#     regexp = new RegExp($(this).data('id'), 'g')
#     $(this).before($(this).data('fields').replace(regexp, time))
#     event.preventDefault()
$ ->
  c = 0
  $('div.replay').each ->
    c += 1
    switch c
      when 1
        $(@).text ''
      else
        $(@).text '再' + '々'.repeat(c - 2) + '試合'

  $('form').on 'fields_added.nested_form_fields', (event, param) ->
    c = 0
    $('.nested_fields').each ->
      if $(@).css('display') != "none"
        c += 1
        replay_elem = $(@).children('div.field').children('div.replay')
        switch c
          when 1
            replay_elem.text ''
          else
            replay_elem.text '再' + '々'.repeat(c - 2) + '試合'

  $('form').on 'fields_removed.nested_form_fields', (event, param) ->
    c = 0
    $('.nested_fields').each ->
      if $(@).css('display') != "none"
        c += 1
        replay_elem = $(@).children('div.field').children('div.replay')
        switch c
          when 1
            replay_elem.text ''
          else
            replay_elem.text '再' + '々'.repeat(c - 2) + '試合'
