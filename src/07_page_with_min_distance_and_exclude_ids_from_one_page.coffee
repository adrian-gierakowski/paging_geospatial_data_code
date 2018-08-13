flow           = require "lodash/fp/flow"
map            = require "lodash/fp/map"
values          = require "lodash/fp/values"
takeRightWhile = require "lodash/fp/takeRightWhile"

log_json                    = require "./helpers/log_json"
with_collection_with_points = require "./helpers/with_collection_with_points"


get_last_distance = ( current_page ) ->

  current_page[ current_page.length - 1 ]?.calculated_distance


get_ids_to_exclude = ( current_page ) ->

  last_distance = get_last_distance current_page

  if last_distance?

    flow(
      takeRightWhile ( doc ) -> doc.calculated_distance is last_distance
      map "_id"
    ) current_page


fetch_page = ( collection, coordinates, options ) ->

  { exclude_ids, last_distance, page_size } = options if options?

  if exclude_ids?

    query = _id : $nin : exclude_ids


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
  [ 0, -15 ]
  [ 0, 30 ]
  [ 0, 45 ]
  [ 0, 60 ]
]

points_not_ok = [
  [ 0, 0 ]
  [ 0, 15 ]
  [ 0, 15 ]
  [ 0, -15 ]
  [ 0, 30 ]
  [ 0, 45 ]
]


run_example = ( points, page_size ) ->

  query_point = [ 0, 0 ]

  with_collection_with_points points, ( collection ) ->

    fetch_page collection, query_point, { page_size }
    .then ( page_1 ) ->

      console.log "\npage_1"
      log_json page_1

      exclude_ids   = get_ids_to_exclude page_1
      last_distance = get_last_distance page_1

      options = { page_size, exclude_ids, last_distance }

      fetch_page collection, query_point, options

    .then ( page_2 ) ->

      console.log "\npage_2"
      log_json page_2

      exclude_ids   = get_ids_to_exclude page_2
      last_distance = get_last_distance page_2

      options = { page_size, exclude_ids, last_distance }

      fetch_page collection, query_point, options

    .then ( page_3 ) ->

      console.log "\npage_3"
      log_json page_3


run_example points_ok, 3
.then -> run_example points_not_ok, 2
