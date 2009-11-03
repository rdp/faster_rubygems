require 'rubygems'

# stolen from http://wiki.github.com/rdp/ruby_tutorials_core/gem

puts File.dirname(__FILE__)
a = File.expand_path(File.dirname(__FILE__)) + "/../install.rb" # install it for them
load a

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close