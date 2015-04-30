fs = require 'fs'
path = require 'path'
{$} = require 'space-pen'

module.exports = class Page

  constructor: ->
    @$el = $('body')


  render: (str) ->
    # this needs to be all the fields to control the server
    # str = """
    # <div><span><input type="text"></span></div>
    # <div><span></span></div>

    # """
    # str = JSON.stringify data

    @$el.html str