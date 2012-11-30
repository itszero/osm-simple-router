require File.expand_path('../lib/osm_simple_router/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chien-An Zero Cho"]
  gem.email         = ["itszero@gmail.com"]

  gem.description   = %q{A simple A* pathfinder using OpenStreetMap data}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/itszero/osm-simple-router"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  #gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "osm-simple-router"
  gem.require_paths = ["lib"]
  gem.version       = OSMSimpleRouter::VERSION

  gem.add_dependency "algorithms", ">= 0.5.0"
  gem.add_dependency "builder", ">= 3.1.4"
  gem.add_dependency "georuby", ">= 2.0.0"
  gem.add_dependency "osmlib-base", ">= 0.1.4"
end
