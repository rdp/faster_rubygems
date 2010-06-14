if RUBY_VERSION < '1.9'
  require File.dirname(__FILE__) + '/faster_rubygems_lib.rb'
  all = FasterRubyGems.gem_prelude_paths
  
  all.each{|path|
    $: << path
  }
  
  module Kernel
    
    def gem *args
      undef :gem
      require 'rubygems' # punt!
      gem *args
    end    
    
  end
  
  module ::Gem
    def self.const_missing const
      require 'rubygems' # punt!
      return Gem.const_get(const)
    end
    
    def self.method_missing meth, *args
      require 'rubygems' # punt!
      return Gem.send(meth, *args)
    end
  end
  
  
else
 # not needed in 1.9, which by default loads gem_prelude
end
