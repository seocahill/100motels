$ ->
  mediaPreview = (e) ->
    e.preventDefault()
    media = $(@).data("media")
    $('#media-frame').html(media)
    $('#preview-modal').modal()

  $("#requests td a").click mediaPreview
