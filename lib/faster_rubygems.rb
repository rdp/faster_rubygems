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
      raise 'only needed on 1.8 -- for 1.9 you have to do $ export RUBYOPT=$RUBYOPT -rfaster_rubygems' if RUBY_VERSION < '1.9.0'
      require 'fileutils'
      old =  $LOADED_FEATURES.detect{|path| path =~ /\/rubygems.rb$/}
      FileUtils.cp old, old + ".bak.rb"
      File.open(old, 'w') do |f|
        f.write "require 'faster_rubygems'"
      end
    end
    
    def self.rubygems_path
      Gem::Dependency
      $LOADED_FEATURES.detect{|path| path =~ /\/rubygems.rb$/}
    end
    
    def self.uninstall_over_rubygems!
      raise 'only needed on 1.8' if RUBY_VERSION < '1.9.0'
      require 'fileutils'
      old = rubygems_path + ".bak.rb"
      FileUtils.cp old, rubygems_path
      File.delete old
    end
  end
end

  