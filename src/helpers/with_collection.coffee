# takes a function ( fn ) and executes it with mongodb collection after
# connecting to a local database
# fn is expected to return a promise
# disposer pattern is used to close mongodb connection no matter what happens

mongodb  = require "mongodb"
bluebird = require "bluebird"


{ MongoClient } = mongodb


connect_url      = "mongodb://localhost:27017"
db_name          = "geo_paging_tutorial"
collection_name  = "locations"
connect_options  =
 useNewUrlParser : true
 promiseLibrary  : bluebird


module.exports = ( fn ) ->

  client_disposer =
    MongoClient.connect connect_url, connect_options
    .disposer ( client ) -> client.close()


  bluebird.using client_disposer, ( client ) ->

    collection = client
      .db db_name
      .collection collection_name

    fn collection
