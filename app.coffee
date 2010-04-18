sys: require("sys")
call: require("./vendor/call")

# Override the default error with your own
call.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

call.get '/', "index.html"

call.get '/main.css', "public/stylesheets/main.css"

call.get '/jquery.js', 'lib/jquery.js'

call.get '/coffee.js', 'lib/coffee-script.js', (env) ->
    sys.puts "running a process"
    env.deliver()
