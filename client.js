var head= document.getElementsByTagName('head')[0];
_sio.type= 'text/javascript';
head.appendChild(_sio);

var loaderInterval = setInterval(function() { 
    try {
      if (typeof io !== "undefined" && typeof io.connect === "function") {
          clearInterval(loaderInterval);
          var wsrsocket = io.connect( _serverAddress );
          wsrsocket.on('connect', function() {
            wsrsocket.on('reload', function (data) {
                window.location.reload();
            });
            wsrsocket.emit('register', _id);
          });
      }
    } catch (e) {
        //nothin!
    }
}, 200);