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
    return exports.routes[path].process = process;
  };
  exports.error = function error(res) {
    res.writeHead(404, {
      'Content-Type': 'text/html'
    });
    return res.write("No route matched.");
  };
  http.createServer(function(req, res) {
    var _a, contentType, extension, file, path;
    path = url.parse(req.url).pathname;
    if (path in exports.routes) {
      extension = path.match(/(.*)\.(.+)/);
      if (extension !== null) {
        if ((_a = extension[2]) === "css") {
          contentType = "text/css";
        } else if (_a === "html") {
          contentType = "text/html";
        } else if (_a === "js") {
          contentType = "text/javascript";
        } else {
          sys.puts("case not handled yet");
        }
      } else {
        contentType = "text/html";
      }
      exports.routes[path].process();
      file = exports.routes[path].GET;
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
