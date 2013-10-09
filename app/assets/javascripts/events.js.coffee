# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Order Total method
orderTotal = (quantity, price) ->
  quantity = $('#order_quantity').val()
  price = $('.price').data('original-content')
  net_price = quantity * price
  gross = (net_price / .961) + 0.30
  order_price = if price > 0 then gross else 0.0
  $('.order-total').html(order_price.toFixed(2))
  $('.stripe-button').attr('data-amount', gross.toFixed(2) * 100)


$('.best_in_place').bind "ajax:success", (event, data) ->
 $.ajax $(this).data(window.location.pathname),
  type: 'GET'
  dataType: 'html'
  error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
  success: (data, textStatus, jqXHR) =>
    target = $(this).data('attribute')
    content = $(data).find(".#{target}").html()
    $(".#{target}").html content
    if target is 'address' then $(".location-city").html $(data).find(".location-city").html()
    orderTotal()
    $('#order_quantity').on "change", orderTotal

$ ->
  $('.best_in_place').best_in_place()

# Sum Order
$ ->
  orderTotal()
  $('#order_quantity').on "change", orderTotal()

#  slimScroll for about piece in event show
$ ->
  $(".about-event").slimScroll height: '250px'

# backSretch
$ ->
  $(".event-header").backstretch($("#event-banner").data('url'))

# Progress bar
$ ->
  width = $('.bar').data('funded')
  $('.bar').css("width", "#{width}%")