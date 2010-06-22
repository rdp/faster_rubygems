# :stopdoc:

# don't load it if normal rubygems is already defined
if defined?(Gem) && !defined?(Gem::FasterRubygems)

  if RUBY_VERSION < '1.9.0'    
    # define it so gem_prelude will execute...
    module Gem; 
      module FasterRubygems; end
    end 
    
    require File.expand_path(File.dirname(__FILE__)) + "/my_gem_prelude.rb"
  end
  
  # both 1.8 and 1.9 want this one though...
  require File.expand_path(File.dirname(__FILE__)) + "/prelude_bin_path"
  
else
  if $VERBOSE || $DEBUG
    puts 'warning: faster_rubygems unable to load because normal rubygems already loaded (expected in certain instances, like when running the gem command)'
  end
end