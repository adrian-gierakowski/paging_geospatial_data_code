log_json        = require "./helpers/log_json"
with_collection = require "./helpers/with_collection"


with_collection ( collection ) ->

  collection
  .find()
  .toArray()

  .then log_json
