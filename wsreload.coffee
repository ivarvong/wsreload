express = require 'express'
http = require 'http'
fs = require 'fs'

app = express.createServer()
server = app.listen 2020
io = require('socket.io').listen server
io.set 'log level', 1

app.configure ->
  app.use express.logger("dev")
  app.use express.static(__dirname + "/public")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

serverAddress = "http://dev.dailyemerald.com:2020"

clientTemplate = fs.readFileSync './client.js'

socketLookup = {}
sendReloads = (id) ->
  numSent = 0
  for socketId in socketLookup[id]
    if socketId of io.sockets.sockets
      io.sockets.sockets[socketId].emit 'reload'
      numSent++
  socketLookup[id] = []
  console.log "+++ Reloaded", numSent, "clients for", id
  numSent + " reloaded\n"
  
app.configure "development", ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.send 'embed a script tag. then curl the id. done.'

app.get '/:id.js', (req, res) ->
  clientScript = "var _id = \"" + encodeURIComponent(req.params.id) + "\";\n" #is this safe?
  clientScript += "var _serverAddress=\"" + serverAddress + "\"\n";
  clientScript += "var _sio= document.createElement('script');\n"
  clientScript += "_sio.src= '" + serverAddress + "/socket.io/socket.io.js';\n"
  clientScript += clientTemplate
  res.send clientScript

app.get '/reload/:id', (req, res) ->
  res.send sendReloads req.params.id

io.sockets.on 'connection', (socket) ->
  #console.log socket
  socket.on 'register', (id) ->
    if id not of socketLookup
      socketLookup[id] = []  
    socketLookup[id].push socket.id  
      	    
console.log "Express server listening on port 2020"
