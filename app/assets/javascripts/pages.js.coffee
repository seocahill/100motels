# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# scrollspy nav with animation
# $("#content").scrollspy()

# () ->
#   $("#content").scrollspy()
  $("#welcome-nav ul li a").bind "click", (e) ->
    e.preventDefault()
    target = @hash
    console.log target
    $.scrollTo target, 1000


# knock off auto slide on smaller carousel
$("#events-carousel").carousel({
  interval: false;
});