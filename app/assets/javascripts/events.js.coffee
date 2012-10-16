# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Sum Order

$ ->
  defaultTotal = ->
    price = $('#ticket-price').data('url')
    $('.stripe-button').data("amount", price)
    $('#total-price').html(price)

  orderTotal = ->
    quantity = $('#order_quantity').val()
    price = $('#ticket-price').data('url')
    total = quantity * price
    $('#total-price').html(total)

  defaultTotal()
  $('#order_quantity').click(orderTotal)