# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Sum Order
$ ->
  orderTotal()
  $('#order_quantity').on "change", orderTotal

# Order Total method
orderTotal = ->
  quantity = $('#order_quantity').val()
  price = $('.ticket-price').data('original-content')
  total = quantity * price
  stripe_fees = (total * 0.029) + 0.3
  motel_fees = total * 0.01
  gross = total + stripe_fees + motel_fees
  number = parseFloat(gross).toFixed(2)
  $('.order-total').html(number)
  $('.stripe-button').attr('data-amount', total)

# $ ->
#   price = $('.ticket-price').data('original-content')
#   number = parseInt( price, 10 )
#   $('.order-total').html(number)

# Toggle checkboxes
$ ->
  $('#check_all').click () ->
    $('input[type="checkbox"]').click()

# Filter form for index page
$ ->
  $('#event_city').change ->
    $(this).closest('form').trigger('submit')

# Best in place functions
jQuery ->
  $('.best_in_place').best_in_place()

$ ->
  $(".best_in_place").bind "ajax:success", ->
    $(this).closest('tr').effect('highlight')

# Jquery Ui Datepicker
jQuery ->
  $.datepicker.setDefaults()

# Tooltips and popovers
$ ->
  $("body").popover selector: "[data-toggle=\"popover\"]"
  $("body").tooltip selector: "a[rel=\"tooltip\"], [data-toggle=\"tooltip\"]"
