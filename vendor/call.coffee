fs: require("fs")
http: require("http")
sys: require("sys")
url: require("url")

exports.routes: {}

exports.get: (path, file, process) ->
  exports.routes[path] ||= {}
  exports.routes[path].GET: ->
    fs.readFileSync file
  exports.routes[path].process: process

exports.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "No route matched."

http.createServer((req, res) ->
  path: url.parse(req.url).pathname
  if path in exports.routes

    extension: path.match(/(.*)\.(.+)/)
    if extension isnt null
      switch extension[2]
        when "css"
          contentType: "text/css"
        when "html"
          contentType: "text/html"
        when "js"
          contentType: "text/javascript"
        else
          sys.puts "case not handled yet"
    else
      contentType: "text/html"

    exports.routes[path].process()
    file: exports.routes[path].GET
    if file?
      res.writeHead 200, {'Content-Type': contentType}
      res.write file()
    else
      exports.error(res)
    sys.puts path
  else
    exports.error(res)
  res.close()
).listen 5678, 'localhost'
sys.puts "Listening on port 5678"
