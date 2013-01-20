# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Sum Order
$ ->
  $('#order_quantity').click ->
    orderTotal()
  $('.stripe-button').click(orderTotal())
  $('#buy-now').click(orderTotal())

# Order Total for stripe button
orderTotal = ->
  quantity = $('#order_quantity').val()
  price = $('#ticket-price').data('url')
  total = quantity * price
  $('.stripe-button').attr('data-amount', total)
  $('.order-total').html(total / 100)

# toggle checkboxes
$ ->
  $('#check_all').click () ->
    $('input[type="checkbox"]').click()

#filter form
$ ->
  $('#event_city').change ->
    $(this).closest('form').trigger('submit')

# BIP
jQuery ->
  $('.best_in_place').best_in_place()

$ ->
  $(".best_in_place").bind "ajax:success", ->
    $(this).closest('tr').effect('highlight')

# Jquery Ui Datepicker
jQuery ->
  $.datepicker.setDefaults()

# Getting Started Modal
$ ->
  window.onload = ->
    $('#gettingStarted').modal() if $('#gettingStarted').data('guest') == true
