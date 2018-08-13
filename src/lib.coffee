flow           = require "lodash/fp/flow"
map            = require "lodash/fp/map"
takeRightWhile = require "lodash/fp/takeRightWhile"


get_last_distance = ( current_page ) ->

  current_page[ current_page.length - 1 ]?.calculated_distance


get_ids_to_exclude = ( current_page, previous_options ) ->

  last_distance = get_last_distance current_page

  if last_distance?

    exclude_ids = flow(
      takeRightWhile ( doc ) -> doc.calculated_distance is last_distance
      map "_id"
    ) current_page

    if last_distance is previous_options?.last_distance

      exclude_ids.concat previous_options.exclude_ids

    else

      exclude_ids


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


module.exports = {
  get_last_distance
  get_ids_to_exclude
  fetch_page
}
