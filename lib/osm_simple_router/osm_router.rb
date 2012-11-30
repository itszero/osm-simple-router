#!/usr/bin/env ruby
require 'rubygems'
require 'geo_ruby'
require 'algorithms'

module OSMSimpleRouter
  class OSMRouter
    include GeoRuby::SimpleFeatures
    include Containers

    def initialize(map, &way_filter)
      @data = {}
      puts "** OSMRouter: Initializing router"

      init_map(map, way_filter)
      @queue = PriorityQueue.new
    end

    def route(p1, p2, &blk)
      if !p1.is_a? Point
        p1 = Point.from_coordinates(p1)
      end

      if !p2.is_a? Point
        p2 = Point.from_coordinates(p2)
      end

      puts "** OSMRouter: Start routing from (#{p1.lat}, #{p1.lon}) to (#{p2.lat}, #{p2.lon})"
      starts = find_closest_node(p1, 5)
      goals = find_closest_node(p2, 5)

      starts.product(goals) do |start, goal|
        result = route_by_node(start, goal, &blk)
        return result unless result[0] == :no_route
      end

      [:no_route, [], -1]
    end

    def route_by_node(start, goal, &blk)
      puts "** OSMRouter: Start node chosen #{start.inspect}"
      puts "** OSMRouter: Goal node chosen #{goal.inspect}"
      closedSet = []
      queuedSet = []
      @queue = PriorityQueue.new
      blankQueueItem = { :distance =>0, :nodes => [start.id] }
      @data[:link][start.id].each do |to|
        next if (closedSet.include? to) or (queuedSet.include? to)
        queuedSet << to
        addToQueue(start.id, to, goal.id, blankQueueItem, &blk)
      end

      while @queue.size > 0
        nextItem = @queue.pop
        x = nextItem[:to]
        next if closedSet.include? x
        if x == goal.id
          return [:ok, nextItem[:nodes].map { |nid| @data[:nodes][nid] }, nextItem[:distance]]
        end
        closedSet << x
        @data[:link][x].each do |to|
          next if (closedSet.include? to) or (queuedSet.include? to)
          queuedSet << to
          addToQueue(x, to, goal.id, nextItem, &blk)
        end
      end
      return [:no_route, [], -1]
    end

    private
    def init_map(map, way_filter)
      @data[:ways] = way_filter.nil? ? map[:ways].values : map[:ways].values.select { |way| way_filter.call(way) }
      @data[:ways].each { |way| way.nodes.map!(&:to_i) }
      puts "** OSMRouter: #{@data[:ways].size} ways loaded"

      @data[:link] = Hash.new { |h, k| h[k] = [] }
      @data[:nodes] = {}
      @data[:ways].each do |way|
        way.nodes.each do |node_id|
          @data[:nodes][node_id] = map[:nodes][node_id] unless map[:nodes][node_id].nil?
        end
        way.nodes.each_cons(2) do |from_id, to_id|
          node_from, node_to = @data[:nodes][from_id], @data[:nodes][to_id]
          next if node_from.nil? or node_to.nil?
          @data[:link][from_id] << to_id
          @data[:link][to_id] << from_id
        end
      end
      @data[:link].each do |key, value|
        @data[:link][key] = value.uniq
      end
      puts "** OSMRouter: #{@data[:nodes].size} nodes loaded"
    end

    def find_closest_node(point, num=1)
      @data[:nodes].values.sort_by { |node|
        node.point.spherical_distance(point)
      }.take(num)
    end

    def addToQueue(start, to, goal, data, &blk)
      node_start = @data[:nodes][start]
      node_to = @data[:nodes][to]
      node_goal = @data[:nodes][goal]
      distance = node_start.point.spherical_distance(node_to.point)
      predictionDistance = distance + (blk.nil? ? node_to.point.spherical_distance(node_goal.point) : blk.call(node_start, node_to, node_goal))

      currentDistance = data[:distance]
      queueItem = {
        :distance => currentDistance + distance,
        :predictionDistance => currentDistance + predictionDistance,
        :nodes => data[:nodes] + [to],
        :to => to
      }
      @queue.push(queueItem, -queueItem[:predictionDistance])
    end
  end
end
