fs: require("fs")
http: require("http")
sys: require("sys")
url: require("url")

exports.routes: {}

exports.file: ->
  if typeof arguments[arguments.length-1] is "function"
    process: arguments.pop()

  path: arguments[0]
  if arguments.length is 1
    file: path.substring(1)
  else
    file: arguments[1]

  exports.routes[path] ||= {}
  exports.routes[path].GET: ->
    fs.readFileSync file
  exports.routes[path].process: process if process?
 
exports.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "No route matched."

http.createServer((req, res) ->
  path: url.parse(req.url).pathname
  if path in exports.routes

    types: {
      css : "text/css"
      html: "text/html"
      js  : "text/javascript"
      jpg : "image/jpeg"
    }

    extension: path.match(/(.*)\.(.+)/)
    if extension?
      contentType: types[extension[2]] 
    else
      contentType: "text/html"
      
    deliver: ->
      file: exports.routes[path].GET

      
      # thing: fs.readFile file, (err, data) ->
      #         contentLength: data.length

      # sys.puts thing  
      if file?
        res.writeHead 200, {'Content-Type': contentType, "Content-Length": 9000}
        res.write file()
      else
        exports.error(res)
      sys.puts path
      res.close()
      
    if exports.routes[path].process?
      exports.routes[path].process {deliver: deliver}
    else
      deliver()
  else
    exports.error(res)
    res.close()
).listen 5678, 'localhost'
sys.puts "Listening on port 5678"
