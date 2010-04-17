http: require("http")
sys: require("sys")
url: require("url")

exports.routes: {}

exports.get: (url, process) ->
  exports.routes[url] ||= {}
  exports.routes[url].GET: process

exports.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "No route matched."

http.createServer((req, res) ->
  path: url.parse(req.url).pathname
  if path in exports.routes
    process: exports.routes[path].GET
    if process?
      res.writeHead 200, {'Content-Type': 'text/html'}
      res.write process()
    else
      exports.error(res)
  else
    exports.error(res)
  res.close()
).listen 5678, 'localhost'
sys.puts "Listening on port 5678"
