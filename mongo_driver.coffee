mongo = require 'mongodb'
server = new mongo.Server 'localhost', 27017, auto_reconnect: true

exports.db = (db_name, collection_names..., callback) ->
  db = new mongo.Db db_name, server
  db.open (err, db) ->
    count = 0
    collections = {}
    for name in collection_names
      db.collection name, (err, collection) ->
        collections[name] = collection
        if ++count == collection_names.length
          callback(collections)

exports.ObjectID = mongo.ObjectID
