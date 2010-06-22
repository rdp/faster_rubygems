# :stopdoc:

if RUBY_VERSION < '1.9.0'
  raise 'rubygems was already loaded?' if defined?(Gem) && !defined?(Gem::FasterRubygems)
  
  # define it so gem_prelude will execute...
  module Gem; 
    module FasterRubygems; end
  end 
  
  require File.expand_path(File.dirname(__FILE__)) + "/my_gem_prelude.rb"
end

# both 1.8 and 1.9 now want this one though...
require File.expand_path(File.dirname(__FILE__)) + "/prelude_bin_path"