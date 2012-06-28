express = require 'express'
http = require 'http'
fs = require 'fs'

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

whoami = "http://dev.dailyemerald.com:2020"

clientTemplate = fs.readFileSync './client.js'

app.configure "development", ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.send 'nope'

app.get '/client/:id', (req, res) ->
  clientScript = "var _idRef = '" + encodeURIComponent req.param.id + "'\n" #is this safe?
  clientScript += clientTemplate
  res.send clientScript

app.get '/reload/:id', (req, res) ->
  io.sockets.emit 'reload'  
  res.send 'sent'

io.sockets.on 'connection', (socket) ->
  console.log socket
	    
console.log "Express server listening on port 2020"
