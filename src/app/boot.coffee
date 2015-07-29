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

# printing utils
print_by_keys = (obj) -> "<div>#{("<div>#{k}: #{v}</div>" for k,v of obj).join('')}</div>"
pretty_obj = (obj) -> CJSON.stringify obj


start_up_server = ->
  OK_HANDLER = (data = 'OK') ->
    (req, res) -> res.status(200).send(data)

  app = express()
  expressWs app

  router.use (req, res, next) ->
    log_to_webpage "request - #{req.method} #{req.url} #{("#{k}=#{v}" for k, v of req.query).join(' ')}"
    next()

  # ----------------- RULE ROUTES ---------------
  router.route('/rule')
        .get(OK_HANDLER())
        .post(OK_HANDLER())

  router.route('/rule/:id')
        .get(OK_HANDLER())
        .put(OK_HANDLER())
        .patch(OK_HANDLER())
        .delete(OK_HANDLER())
  # --------------- / RULE ROUTES ---------------

  # ----------------- WATCH ROUTES ---------------
  router.route('/watch/:artifact-uuid/user/:user-uuid')
        .get(OK_HANDLER())
        .post(OK_HANDLER())
        .delete(OK_HANDLER())

  router.route('/watch/user/:user-uuid')
        .get(OK_HANDLER())

  router.route('/watch/:artifact-uuid')
        .get(OK_HANDLER())
        .post(OK_HANDLER())
        .delete(OK_HANDLER())

  router.route('/watch/')
        .get(OK_HANDLER())
  # --------------- / WATCH ROUTES ---------------


  # ----------------- WEBHOOK ROUTES ---------------
  router.route('/webhook')
        .get(OK_HANDLER('webhook'))
  # --------------- / WEBHOOK ROUTES ---------------

  router.route('/email_enabled')
        .get(OK_HANDLER())

  app.ws '/_websocket', (ws, res) ->
    ws.on 'message', (msg) ->
      log_to_webpage "weboscket got message: #{msg}"

  app.use '/notifications/api/v1', router
  # app.use router

  app.all '*', (req, res) ->
    log_to_webpage "#{req.method} #{req.url}: fell through to default handler"
    res.status(200).send('default handler')

  server = app.listen '3200'

  url = "http://localhost:#{3200}"

  log_to_webpage """starting server: #{url}"""
  log_to_webpage JSON.stringify app

$ ->
  PAGE = new Page()
  PAGE.render()

  start_up_server()
