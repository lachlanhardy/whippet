fs: require("fs")
call: require("./vendor/call")

# Override the default error with your own
call.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

call.get '/', ->
  fs.readFileSync "index.html"

call.get '/jquery.js', ->
  fs.readFileSync 'lib/jquery.js'

call.get '/coffee.js', ->
  fs.readFileSync 'lib/coffee-script.js'
