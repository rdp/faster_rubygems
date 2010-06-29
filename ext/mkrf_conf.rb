require 'rubygems'

# do some ruby stuff...

load File.expand_path(File.dirname(__FILE__)) + "/../internalize.rb" # install this gem locally...

# create as many as possible at install time ...

require File.dirname(__FILE__) + "/../lib/faster_rubygems/create_cache_for_all.rb"


if RUBY_VERSION[0..2] == '1.8'
  begin
    require File.dirname(__FILE__) + "/../lib/faster_rubygems/override.rb" # install it by default...
  rescue RuntimeError => e
    # swallow if it's a double install...for now...
    raise e unless e.to_s =~ /cannot install twice/
  end

end


f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w") # create dummy rakefile to indicate success
f.write("task :default\n")
f.close