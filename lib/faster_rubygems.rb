# :stopdoc:

# don't load it if normal rubygems is already defined
if !defined?(Gem::Dependency)

  if RUBY_VERSION < '1.9.0'    
    # define it so gem_prelude will execute...
    module Gem; 
    end     
    require File.expand_path(File.dirname(__FILE__)) + "/my_gem_prelude.rb"
  end

  # both 1.8 and 1.9 want this one always though...
  require File.expand_path(File.dirname(__FILE__)) + "/prelude_bin_path"

  
  module Gem
    module QuickLoader
    # 1.9.1's gem_prelude doesn't have this for some reason...
    def integers_for(gem_version)
        numbers = gem_version.split(".").collect {|n| n.to_i}
        numbers.pop while numbers.last == 0
        numbers << 0 if numbers.empty?
        numbers
    end unless respond_to?(:integers_for)
  end
  extend QuickLoader
 end

  
  
else
  if $VERBOSE || $DEBUG
    puts 'warning: faster_rubygems unable to load because normal rubygems already loaded (expected in certain instances, like when running the gem command)'
  end
end

