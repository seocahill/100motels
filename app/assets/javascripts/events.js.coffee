# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Sum Order

$ ->
  $('#order_quantity').click(orderTotal)
  orderTotal()

orderTotal = ->
  quantity = $('#order_quantity').val()
  price = $('#ticket-price').data('url')
  total = quantity * price
  $('.stripe-button').attr('data-amount', total)

# toggle checkboxes
$ ->
  $('#check_all').click () ->
    $('input[type="checkbox"]').click()
