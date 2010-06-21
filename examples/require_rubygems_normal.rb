require 'benchmark'
puts Benchmark.realtime {
  require 'rubygems'
  gem 'ruby-prof'
  Gem.bin_path('ruby-prof')
  require 'ruby-prof' # load a gem
}
