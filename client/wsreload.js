var head= document.getElementsByTagName('head')[0];
var _sio= document.createElement('script');
_sio.type= 'text/javascript';
_sio.src= 'http://dev.dailyemerald.com:8301/socket.io/socket.io.js';
head.appendChild(_sio);

setTimeout(function() {
  var socket = io.connect('http://dev.dailyemerald.com:2020');
  socket.on('reload', function (data) {
    window.location.reload();
  });
}, 300);
