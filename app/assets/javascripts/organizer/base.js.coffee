$ ->
  mediaPreview = (e) ->
    e.preventDefault()
    media = $(@).data("media")
    $('#media-frame').html(media)
    $('#preview-modal').modal()

  $("#requests td a").click mediaPreview

#filter form
$ ->
  $('#organizer_city').change ->
    $(this).closest('form').trigger('submit')

#datepicker
$ ->
  $('.datepicker').datepicker