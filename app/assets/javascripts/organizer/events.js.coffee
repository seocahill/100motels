# Changing css on status labels

$ ->
  $("#organizer-customers td span").each ->
    label = $(@)
    switch
      when  label.html() is "refunded" then label.addClass('label-important')
      when  label.html() is "pending" then label.addClass('label-warning')
      when  label.html() is "paid" then label.addClass('label-success')

