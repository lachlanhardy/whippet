(function(){
  var http, sys, url;
  http = require("http");
  sys = require("sys");
  url = require("url");
  exports.routes = {};
  exports.get = function get(url, process) {
    exports.routes[url] = exports.routes[url] || {};
    return exports.routes[url].GET = process;
  };
  exports.error = function error(res) {
    res.writeHead(404, {
      'Content-Type': 'text/html'
    });
    return res.write("No route matched.");
  };
  http.createServer(function(req, res) {
    var path, process;
    path = url.parse(req.url).pathname;
    if (path in exports.routes) {
      process = exports.routes[path].GET;
      if ((typeof process !== "undefined" && process !== null)) {
        res.writeHead(200, {
          'Content-Type': 'text/html'
        });
        res.write(process());
      } else {
        exports.error(res);
      }
    } else {
      exports.error(res);
    }
    return res.close();
  }).listen(5678, 'localhost');
  sys.puts("Listening on port 5678");
})();
