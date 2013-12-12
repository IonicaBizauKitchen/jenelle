express  = require "express"
logfmt   = require "logfmt"
db       = require "./models"

app = express()
app.set('view engine', 'jade')
app.use express.json()
app.use express.urlencoded()
app.use logfmt.requestLogger()
app.use app.router
app.use '/public', express.static('public')

auth = express.basicAuth('', 'foo')

app.get "/", (req, res) ->
  db.Post.findAll({order: 'id DESC'}).success (posts) ->
    res.render "index",
      posts: posts

app.get "/posts", auth, (req, res) ->
  db.Post.findAll({order: 'id DESC'}).success (posts) ->
    res.render "posts/index",
      posts: posts

app.get "/posts/new", auth, (req, res) ->
  res.render "posts/new",
    post: {}

app.get "/posts/edit/:id", auth, (req, res) ->
  db.Post.find(req.params.id).success (post) ->
    res.render "posts/edit",
      post: post

app.post "/posts", auth, (req, res) ->
  if req.body.id
    db.Post.update(req.body, {id: req.body.id}).success ->
      res.redirect "/posts"
  else
    db.Post.create(req.body).success (post) ->
      res.redirect "/posts"

db.sequelize.sync().complete (err) ->
  throw err if err
  app.listen(process.env.PORT or 5000)