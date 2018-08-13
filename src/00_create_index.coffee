log_json        = require "./helpers/log_json"
with_collection = require "./helpers/with_collection"


with_collection ( collection ) ->

  keys    = location : "2dsphere"
  options = background : yes

  collection.createIndex keys, options
  .then log_json
