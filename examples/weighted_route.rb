#!/usr/bin/env ruby
require 'rubygems'
require 'osm_loader'
require 'osm_router'
require 'geo_ruby'
include GeoRuby::SimpleFeatures
require 'json'
require 'open-uri'

puts "** Loading GaTech OSM map"
data = OSMLoader.load("gatech.osm")
router = OSMRouter.new(data) do |way|
  # Use this callback to filter out those road you don't want it to be
  # included for the use of routing.

  # pedestrains paths
  peds_path = [
    'primary', 'secondary', 'tertiary', 'unclassified', 'minor',
    'cycleway', 'residential', 'track', 'service', 'footway', 'steps'
  ]

  peds_path.include? way.tags['highway']
end

# Campus Recreation Center
start = Point.from_coordinates([-84.40330, 33.77587])
# B&N Starbucks
goal = Point.from_coordinates([-84.38858, 33.77683])

puts "** Heat-weighted route"
status, route, distance = router.route(start, goal) do |start, to, goal|
  # factor determination block - return a prediction distance of going from
  # start to "to".
  factor = 1
  grid_name = "#{(to.point.lat * 1E6).to_i / 500 * 500}x#{(to.point.lon * 1E6).to_i / 500 * 500}"
  if grid_name == "3377500x-8439000"
    factor = 100
  end
  to.point.spherical_distance(goal.point) * factor
end
cords = route.map { |n| p = n.point; [p.y, p.x] }
puts "** Route #{status}: #{distance} m, #{route.size} nodes"

puts "** normal route"
status, route, distance = router.route(start, goal)
puts status
cords2 = route.map { |n| p = n.point; [p.y, p.x] }
puts "** Route #{status}: #{distance} m, #{route.size} nodes"

