log_json                    = require "./helpers/log_json"
with_collection_with_points = require "./helpers/with_collection_with_points"

# coordinates of points which will be inserted into collection
points = [
  [ 0, 0 ]
  [ 0, 15 ]
  [ 0, 30 ]
  [ 0, 45 ]
  [ 0, 60 ]
  [ 0, 75 ]
]


with_collection_with_points points, ( collection ) ->

  page_size   = 2
  page_offset = 1

  query =
    location :
      $near :
        $geometry :
          type        : "Point"
          coordinates : [ 0, 0 ]

  collection
  .find query

  .limit page_size
  .skip page_offset * page_size

  .toArray()

  .then log_json
