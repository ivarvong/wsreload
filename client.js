var head= document.getElementsByTagName('head')[0];
var _sio= document.createElement('script');
_sio.type= 'text/javascript';
_sio.src= 'http://dev.dailyemerald.com:2020/socket.io/socket.io.js';
head.appendChild(_sio);

var wsloaded = false;
var wsrsocket;

var loaderInterval = setInterval(function() { 
    try {
      if (io && io.connect) {
          console.log("got io! loading...");
          clearInterval(loaderInterval);
          wsrsocket = io.connect('http://dev.dailyemerald.com:2020');
          wsrsocket.on('reload', function (data) {
              window.location.reload();
          });
          wsrsocket.emit('register', _id)
      }
    } catch (e) {
        //nothin!
    }
}, 200);

var checkLink = setInterval(function() {
  wsrsocket.emit('ping');
},1000*10)

window.onpopstate = function() {
    console.log(document.location);
};
