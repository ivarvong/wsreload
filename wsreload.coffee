express = require 'express'
http = require 'http'

app = express.createServer()
server = app.listen 2020
io = require('socket.io').listen server

app.configure ->
  app.set 'views', __dirname+'/views'
  app.set 'view engine', 'jade'
  app.use express.logger("dev")
  app.use express.static(__dirname + "/public")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

whoami="http://dev.dailyemerald.com:2020"

app.configure "development", ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.send 'nope'

app.get '/bookmarklet', (req, res) ->
  res.send "Make this a bookmarklet: javascript:(function()%7Bvar%20_wsr=document.createElement('script');%20_wsr.type='text/javascript';%20_wsr.src='"+whoami+"/wsreload.js';%20document.getElementsByTagName('head')%5B0%5D.appendChild(_wsr);%7D());"

app.get '/wsreload.js', (req, res) ->
  res.sendfile './client/wsreload.js'

app.get '/reload', (req, res) ->
  io.sockets.emit 'reload'  
  res.send 'sent'
	    

console.log "Express server listening on port 2020"
