
  module FasterRubyGems
    def self.install_over_rubygems! aggressive = false
      raise 'only needed on 1.8 -- for 1.9 you have to do
      $ export RUBYOPT=$RUBYOPT -rfaster_rubygems' if RUBY_VERSION >= '1.9.0'
      require 'fileutils'
      old = rubygems_path
      new =  old + ".bak.rb"
      raise 'cannot install twice--please run uninstall first' if File.exist?(new)
      FileUtils.cp old, new
      File.open(old, 'w') do |f|
        f.write "require 'faster_rubygems'\n"
        f.write "require 'faster_require'" if aggressive
      end
      puts 'success--it will load by default in place of normal rubygems'
    end
    
    def self.rubygems_path
      Gem::Dependency
      raise unless $LOADED_FEATURES.include? "rubygems.rb"
      # now go and look for it
      $:.detect{|path| File.exist?(path + '/rubygems.rb') || File.exist?(path + '/rubygems.rb.bak.rb')} + "/rubygems.rb"
    end
    
    def self.uninstall_over_rubygems!
      raise 'only needed on 1.8' if RUBY_VERSION >= '1.9.0'
      require 'fileutils'
      old = rubygems_path + ".bak.rb"
      FileUtils.cp old, rubygems_path
      File.delete old
      puts 'successfully reverted back to normal rubygems'
    end
  end