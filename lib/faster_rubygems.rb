if RUBY_VERSION < '1.9.0'
  raise 'rubygems was already loaded' if defined?(Gem) 
  module Gem; end # define it so gem_prelude will run...
  require File.dirname(__FILE__) + "/my_gem_prelude.rb"  
end

# both 1.8 and 1.9 now want this one...
require File.dirname(__FILE__) + "/prelude_bin_path"  