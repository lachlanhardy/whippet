(function(){
  var fs, http, sys, url;
  fs = require("fs");
  http = require("http");
  sys = require("sys");
  url = require("url");
  exports.routes = {};
  exports.get = function get(path, file, process) {
    exports.routes[path] = exports.routes[path] || {};
    exports.routes[path].GET = function GET() {
      return fs.readFileSync(file);
    };
    if ((typeof process !== "undefined" && process !== null)) {
      return (exports.routes[path].process = process);
    }
  };
  exports.error = function error(res) {
    res.writeHead(404, {
      'Content-Type': 'text/html'
    });
    return res.write("No route matched.");
  };
  http.createServer(function(req, res) {
    var contentType, extension, file, path, types;
    path = url.parse(req.url).pathname;
    if (path in exports.routes) {
      types = {
        css: "text/css",
        html: "text/html",
        js: "text/javascript"
      };
      extension = path.match(/(.*)\.(.+)/);
      (typeof extension !== "undefined" && extension !== null) ? (contentType = types[extension[2]]) : (contentType = "text/html");
      exports.routes[path].process ? exports.routes[path].process() : null;
      file = exports.routes[path].GET;
      sys.puts(file);
      if ((typeof file !== "undefined" && file !== null)) {
        res.writeHead(200, {
          'Content-Type': contentType
        });
        res.write(file());
      } else {
        exports.error(res);
      }
      sys.puts(path);
    } else {
      exports.error(res);
    }
    return res.close();
  }).listen(5678, 'localhost');
  sys.puts("Listening on port 5678");
})();
