mongo = require './mongo_driver'
ObjectID = mongo.ObjectID

db = null
mongo.db 'foo', 'users', (collections) ->
  db = collections

exports.configure = (r) ->

  r.get '/home', ->
    this.render 'home'

  r.get '/users/new', ->
    this.render 'new'

  r.post '/users', ->
    that = this
    db.users.insert this.params
    db.users.find().toArray (err, items) ->
      that.render 'users', users: items

  r.get '/users/$', (id) ->
    that = this
    db.users.findOne _id: new ObjectID(id), (err, item) ->
      that.render 'show', user: item

  r.get '/users', ->
    that = this
    db.users.find().toArray (err, items) ->
      that.render 'users', users: items

  r.delete '/users/$', (id) ->
    that = this
    db.users.remove _id: new ObjectID(id)
    db.users.find().toArray (err, items) ->
      that.render 'users', users: items
