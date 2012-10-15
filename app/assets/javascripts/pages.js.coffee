# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# scrollspy nav with animation

$ ->
  $("#welcome-nav a").click ->
    goToByScroll $(this).attr("href")
    false


goToByScroll = (id) ->
  $('html,body').animate({scrollTop: $(id).offset().top}, 2600)

# clear form
$ ->
  $("#q_reset").click ->
    $(".search-query").val('')