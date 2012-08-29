# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Geolocation function

jQuery(document).ready ($) ->
  jQuery.getScript "http://www.geoplugin.net/javascript.gp", ->
    country = geoplugin_countryName()
    zone = geoplugin_region()
    district = geoplugin_city()
    $("#geolocation").text country + ", " + zone + ", " + district

