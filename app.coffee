sys: require("sys")
call: require("./vendor/call")

# Override the default error with your own
call.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

call.get '/', "index.html", ->
  sys.puts "this is a callback, bitch!"

call.get '/jquery.js', 'lib/jquery.js', ->
  sys.puts "jquery"

call.get '/coffee.js', 'lib/coffee-script.js', ->
  sys.puts("coffee_bawls")
