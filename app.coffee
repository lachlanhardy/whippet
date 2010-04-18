sys: require("sys")
call: require("./vendor/whippet")

# Replace the default error function with your own
call.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

call.file '/', 'index.html'

call.file '/lib/main.css'

call.file '/lib/jquery.js'

call.file '/lib/coffee-script.js', (env) ->
  sys.puts "running a process"
  env.deliver()

call.file '/whippet2.jpg'
