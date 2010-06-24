require 'rubygems'

# do some ruby stuff...

load File.expand_path(File.dirname(__FILE__)) + "/../internalize.rb" # install this gem locally...

# create as many as possible at install time ...

require File.dirname(__FILE__) + "/../lib/faster_rubygems/create_cache_for_all.rb"

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w") # create dummy rakefile to indicate success
f.write("task :default\n")
f.close