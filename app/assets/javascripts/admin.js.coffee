# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addAnswer = (i, theAnswer) ->
  theURL = "<%= url_for(:controller => 'test_taker', :action => 'update_answers') %>" + "?answer=" + i + ". " + theAnswer
  alert theAnswer
  new Ajax.Request(theURL,
    asynchronous: true
    evalScripts: true
  )
  alert theAnswer+" again"
  return