OpenStreetMap Simple Router
===========================

This is a simple A* pathfinder algorithm implemented for using with
OpenStreetMap Data. It comes with two classes `OSMSimpleRouter::OSMLoader` for
loading *.osm format map and `OSMSimpleRouter::OSMRouter` for routing.

## Features

It supports filtering *ways* to route and dynamic *weighting*. Please refer to
examples/weighted_route.rb for more information.

## Pitfalls

This library depends on [OSMlib-base] for loading OSM files. It uses the slowest
REXML by default. Please refer to its documents if you wish to switch to faster
C-based XML libraries.

## License

Copyright (c) 2012 Chien-An "Zero" Cho

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[osmlib-base]: http://github.com/iampersistent/OSMlib-base
