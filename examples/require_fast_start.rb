require 'benchmark'
puts Benchmark.realtime {
  require File.dirname(__FILE__) + '/../lib/faster_rubygems'
  gem 'ruby-prof'
  Gem.bin_path 'ruby-prof'
  require 'ruby-prof' # load a gem
}
