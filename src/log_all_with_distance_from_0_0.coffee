log_json        = require "./helpers/log_json"
with_collection = require "./helpers/with_collection"


with_collection ( collection ) ->

  pipeline = [
    {
      $geoNear :
        near :
          type        : "Point"
          coordinates : [ 0, 0 ]

        spherical     : yes
        distanceField : "calculated_distance"
    }
  ]

  collection
  .aggregate pipeline
  .toArray()

  .then log_json
