#!/usr/bin/env ruby
require 'rubygems'

ENV['OSMLIB_XML_PARSER']='Expat'
require 'OSM/StreamParser'

module OSMSimpleRouter
  class OSMLoader
    class OSMLoaderCallback < OSM::Callbacks
      @output = {}

      def initialize(output)
        @output = output
        @output[:nodes] = {}
        @output[:ways] = {}
      end

      def node(node)
        @output[:nodes][node.id] = node
      end

      def way(way)
        @output[:ways][way.id] = way
      end
    end

    def self.load(filename)
      results = {}
      cb = OSMLoaderCallback.new(results)
      parser = OSM::StreamParser.new(:filename => filename, :callbacks => cb)
      parser.parse

      results
    end
  end
end
