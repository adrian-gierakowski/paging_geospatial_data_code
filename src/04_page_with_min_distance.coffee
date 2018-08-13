log_json                    = require "./helpers/log_json"
with_collection_with_points = require "./helpers/with_collection_with_points"


fetch_page = ( collection, coordinates, { page_size, last_doc } ) ->

  last_distance = last_doc?.calculated_distance

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
    }
  ]

  collection
  .aggregate pipeline
  .toArray()


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

  query_point = [ 0, 0 ]
  page_size   = 2


  fetch_page collection, query_point, { page_size }
  .then ( previous_page ) ->

    console.log "\npage 1:"
    log_json previous_page

    last_doc = previous_page[ previous_page.length - 1 ]

    fetch_page collection, query_point, { page_size, last_doc }

  .then ( next_page ) ->

    console.log "\npage 2:"
    log_json next_page
