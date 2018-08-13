flow           = require "lodash/fp/flow"
map            = require "lodash/fp/map"
values          = require "lodash/fp/values"
takeRightWhile = require "lodash/fp/takeRightWhile"

log_json                    = require "./helpers/log_json"
with_collection_with_points = require "./helpers/with_collection_with_points"

{
  get_last_distance
  get_ids_to_exclude
  fetch_page
} = require "./lib"


# coordinates of points which will be inserted into collection
points = [
  [ 0, 0 ]
  [ 0, 15 ]
  [ 0, 15 ]
  [ 0, -15 ]
  [ 0, 30 ]
  [ 0, 45 ]
]


with_collection_with_points points, ( collection ) ->

  query_point = [ 0, 0 ]
  page_size   = 2

  fetch_page collection, query_point, { page_size }
  .then ( page_1 ) ->

    console.log "\npage_1"
    log_json page_1

    exclude_ids   = get_ids_to_exclude page_1
    last_distance = get_last_distance page_1

    options_p2 = { page_size, exclude_ids, last_distance }

    fetch_page collection, query_point, options_p2
    .then ( page_2 ) ->

      console.log "\npage_2"
      log_json page_2

      exclude_ids   = get_ids_to_exclude page_2, options_p2
      last_distance = get_last_distance page_2

      options_p3 = { page_size, exclude_ids, last_distance }

      fetch_page collection, query_point, options_p3

  .then ( page_3 ) ->

    console.log "\npage_3"
    log_json page_3
