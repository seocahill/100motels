# Changing css on status labels

$ ->
  $("#organizer-customers td span").each ->
    label = $(@)
    switch
      when  label.html() is "refunded" then label.addClass('label-inverse')
      when  label.html() is "failed" then label.addClass('label-important')
      when  label.html() is "pending" then label.addClass('label-warning')
      when  label.html() is "paid" then label.addClass('label-success')
      when  label.html() is "tickets_sent" then label.addClass('label-success')

$ ->
  $("a[data-toggle=\"tab\"]").on "shown", (e) ->
    $.cookie "last_tab", $(e.target).attr("href")
  lastTab = $.cookie("last_tab")
  if lastTab
    $("a[href=" + lastTab + "]").tab "show"
  else
    $("a[data-toggle=\"tab\"]:first").tab "show"

# Toggle checkboxes
$ ->
  $('#check_all').click () ->
    $('input[type="checkbox"]').click()