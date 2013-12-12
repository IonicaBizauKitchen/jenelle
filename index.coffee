express  = require "express"
logfmt   = require "logfmt"

app = express()
app.set('view engine', 'jade')

# app.use express.bodyParser()
app.use logfmt.requestLogger()
app.use app.router
app.use '/public', express.static('public')

app.get "/", (req, res) ->
  res.render "index"

app.listen(process.env.PORT or 5000)