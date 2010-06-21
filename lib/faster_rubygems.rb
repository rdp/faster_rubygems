if RUBY_VERSION < '1.9.0'
  raise 'rubygems was already loaded' if defined?(Gem) 
  module Gem; end # define it so gem_prelude will execute...
  require File.dirname(__FILE__) + "/my_gem_prelude.rb"  
end

# both 1.8 and 1.9 now want this one though...
require File.dirname(__FILE__) + "/prelude_bin_path"

module Gem
  module FasterRubyGems
    def self.install_over_rubygems!
      old = path_to_full_rubygems_library
      puts old
    end
    
    def self.uninstall_over_rubygems!
    
    end
  end
end

  