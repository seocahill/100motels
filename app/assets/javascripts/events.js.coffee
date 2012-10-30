# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Sum Order
$ ->
  # price = $('#ticket-price').data('url')
  # $('.stripe-button').attr('data-amount', price)
  $('#order_quantity').click ->
    orderTotal()
  $('.stripe-button').click(orderTotal())
  $('#buy-now').click(orderTotal())


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

#popover
$ ->
  $('#buy-now').popover()

changetab
$ ->
  $('.nav li').click (e) ->
    $('.nave li.active').removeClass('active')
    @clicked = $(@)
    unless @clicked.hasClass('active')
      @clicked.addClass('active')
    e.preventDefault

#filter form
$ ->
  $('#event_city').change ->
    $(this).closest('form').trigger('submit')

