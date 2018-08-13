log_json                    = require "./helpers/log_json"
with_collection_with_points = require "./helpers/with_collection_with_points"


fetch_page = ( collection, coordinates, { page_size, last_doc } ) ->

  last_distance = last_doc?.calculated_distance

  if last_doc?

    query = _id : $nin : [ last_doc._id ]


  pipeline = [
    {
      $geoNear :
        near :
          type        : "Point"
          coordinates : coordinates

        spherical     : yes
        minDistance   : last_distance
        distanceField : "calculated_distance"
        limit         : page_size
        query         : query
    }
  ]

  collection
  .aggregate pipeline
  .toArray()


# coordinates of points which will be inserted into collection
points_ok = [
  [ 0, 0 ]
  [ 0, 15 ]
  [ 0, 30 ]
  [ 0, 45 ]
  [ 0, 60 ]
  [ 0, 75 ]
]

points_not_ok = [
  [ 0, 0 ]
  [ 0, 15 ]
  [ 0, -15 ]
  [ 0, 30 ]
  [ 0, 45 ]
  [ 0, 60 ]
]


run_example = ( points, page_size ) ->

  query_point = [ 0, 0 ]

  with_collection_with_points points, ( collection ) ->

    fetch_page collection, query_point, { page_size }
    .then ( previous_page ) ->

      console.log "\npage 1 ( page_size = #{ page_size } ):"
      log_json previous_page

      last_doc = previous_page[ previous_page.length - 1 ]

      fetch_page collection, query_point, { page_size, last_doc }

    .then ( next_page ) ->

      console.log "\npage 2: ( page_size = #{ page_size } ):"
      log_json next_page


run_example points_ok, 2
.then -> run_example points_not_ok, 3
