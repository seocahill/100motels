# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Splash image
$ ->
  $('.splash-image').backstretch("https://s3-us-west-2.amazonaws.com/onehundredmotels/motels_landing_splash.jpg")

# Learn More Scroll
$ ->
  $("a[href^=\"#\"]").on "click", (e) ->
    e.preventDefault()
    target = @hash
    $target = $(target)
    $("html, body").stop().animate
      scrollTop: $target.offset().top
    , 900, "swing", ->
      window.location.hash = target