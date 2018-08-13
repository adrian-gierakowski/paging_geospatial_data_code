# boilerplate for running examples with a collection containing given
# set of points

map = require "lodash/fp/map"

with_collection = require "./with_collection"


doc_with_coords = ( [ longitude, latitude ] ) ->

  location :
    type        : "Point"
    coordinates : [ longitude, latitude ]


module.exports = ( array_of_points, fn ) ->

  console.log "\nrunning example with points [ long, lat ]:", array_of_points

  with_collection ( collection ) ->

    # clear collection
    collection.deleteMany {}
    # insert documents with given locations
    .then -> collection.insertMany map doc_with_coords, array_of_points
    # execute given function, passing in the collection
    .then -> fn collection
