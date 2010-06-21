require 'rubygems'

# do some ruby stuff...

puts File.dirname(__FILE__)
load File.expand_path(File.dirname(__FILE__)) + "/../internalize.rb" # install this gem locally

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w") # create dummy rakefile to indicate success
f.write("task :default\n")
f.close