path = require 'path'
{$} = require 'space-pen'
Page = require './page'

express = require 'express'
expressWs = require('express-ws')
router = express.Router()

CJSON = require('circular-json')
Prettify = require('prettyjson')

logger = (req, res, next) ->
  console.log 'Something is happening'
  next()

BUFFER = []

PAGE = {}

_render = ->
  PAGE.render BUFFER.join ''

log_to_webpage = (str = '') ->
  BUFFER.push "<div>#{str}</div>"
  _render()

print_by_keys = (obj) ->
  "<div>#{("<div>#{k}: #{v}</div>" for k,v of obj).join('')}</div>"


pretty_obj = (obj) ->
  CJSON.stringify obj

OK_HANDLER = (req, res) ->
  debugger

start_up_server = ->

  app = express()
  expressWs app

  router.use (req, res, next) ->
    debugger
    log_to_webpage "request - #{req.method} #{req.url} #{("#{k}=#{v}" for k, v of req.query).join(' ')}"
    # log_to_webpage print_by_keys req
    # log_to_webpage pretty_obj res
    log_to_webpage '----------------'
    next()

  router.route('/rule')
        .get(OK_HANDLER

        ).post((req, res) -> {

        })

  router.route('/rule/:id')
        .get((req, res) ->

        ).put((req, res) -> {

        }).patch((req, res) -> {

        }).delete((req, res) -> {

        })

  router.route('/watch/:artifact-uuid/user/:user-uuid')
        .get((req, res) ->

        ).post((req, res) -> {

        }).delete((req, res) -> {

        })

  router.route('/watch/user/:user-uuid')
        .get((req, res) ->

        )

  router.route('/watch/:artifact-uuid')
        .get((req, res) ->

        ).post((req, res) ->

        ).delete((req, res) ->

        )

  router.route('/watch/')
        .get((req, res) ->

        )

  app.ws '/_websocket', (ws, res) ->
    ws.on 'message', (msg) ->
      log_to_webpage "weboscket got message: #{msg}"

  # app.use '/api/v1', router
  app.use router

  server = app.listen '3200'

  url = "http://localhost:#{3200}"

  log_to_webpage """starting server: #{url}"""
  log_to_webpage JSON.stringify app

$ ->
  PAGE = new Page()
  PAGE.render()

  start_up_server()
