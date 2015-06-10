# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# See https://jsfiddle.net/GuanglinDu/feoxt8yL/
$ ->
  $('.collapse').on 'show.bs.collapse', ->
    $('.collapse.in').collapse 'hide'
