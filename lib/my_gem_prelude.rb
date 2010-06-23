# copied from 1.9.2

# in reality, this file will only be ever run via 1.8

# depends on: array.rb dir.rb env.rb file.rb hash.rb module.rb regexp.rb
# vim: filetype=ruby

# NOTICE: Ruby is during initialization here.
# * Encoding.default_external does not reflects -E.
# * Should not expect Encoding.default_internal.
# * Locale encoding is available.
if defined?(Gem) then
  require 'rbconfig'
  # :stopdoc:

  module Kernel

    def gem(gem_name, *version_requirements)
      Gem.push_gem_version_on_load_path(gem_name, *version_requirements)
    end
    private :gem
  end

  module Gem

    ConfigMap = {
      :EXEEXT            => RbConfig::CONFIG["EXEEXT"],
      :RUBY_SO_NAME      => RbConfig::CONFIG["RUBY_SO_NAME"],
      :arch              => RbConfig::CONFIG["arch"],
      :bindir            => RbConfig::CONFIG["bindir"],
      :libdir            => RbConfig::CONFIG["libdir"],
      :ruby_install_name => RbConfig::CONFIG["ruby_install_name"],
      :ruby_version      => RbConfig::CONFIG["ruby_version"],
      :rubylibprefix     => (RbConfig::CONFIG["rubylibprefix"] ||  RbConfig::CONFIG['rubylibdir'].split('/')[0..-2].join('/')),
      :sitedir           => RbConfig::CONFIG["sitedir"],
      :sitelibdir        => RbConfig::CONFIG["sitelibdir"],
    }

    def self.dir
      @gem_home ||= nil
      set_home(ENV['GEM_HOME'] || default_dir) unless @gem_home
      @gem_home
    end

    def self.path
      @gem_path ||= nil
      unless @gem_path
        paths = [ENV['GEM_PATH'] || default_path]
        paths << APPLE_GEM_HOME if defined? APPLE_GEM_HOME
        set_paths(paths.compact.join(File::PATH_SEPARATOR))
      end
      @gem_path
    end

    def self.post_install(&hook)
      @post_install_hooks << hook
    end

    def self.post_uninstall(&hook)
      @post_uninstall_hooks << hook
    end

    def self.pre_install(&hook)
      @pre_install_hooks << hook
    end

    def self.pre_uninstall(&hook)
      @pre_uninstall_hooks << hook
    end

    def self.set_home(home)
      home = home.dup
      home.gsub!(File::ALT_SEPARATOR, File::SEPARATOR) if File::ALT_SEPARATOR
      @gem_home = home
    end

    def self.set_paths(gpaths)
      if gpaths
        @gem_path = gpaths.split(File::PATH_SEPARATOR)

        if File::ALT_SEPARATOR then
          @gem_path.map! do |path|
            path.gsub File::ALT_SEPARATOR, File::SEPARATOR
          end
        end

        @gem_path << Gem.dir
      else
        # TODO: should this be Gem.default_path instead?
        @gem_path = [Gem.dir]
      end

      @gem_path.uniq!
    end

    def self.user_home
      @user_home ||= File.expand_path("~")
    rescue
      if File::ALT_SEPARATOR then
        "C:/"
      else
        "/"
      end
    end

    # begin rubygems/defaults
    # NOTE: this require will be replaced with in-place eval before compilation.
    require File.dirname(__FILE__) + '/my_defaults.rb'
    # end rubygems/defaults


    ##
    # Methods before this line will be removed when QuickLoader is replaced
    # with the real RubyGems

    GEM_PRELUDE_METHODS = Gem.methods(false)

    begin
      verbose, debug = $VERBOSE, $DEBUG
      $VERBOSE = $DEBUG = nil

      begin
        require 'rubygems/defaults/operating_system'
      rescue ::LoadError
      end

      if defined?(RUBY_ENGINE) then
        begin
          # jruby is not ready for this... 
          # it anticipates altering a full Gem version, currently, in 1.8 mode...
          # require "rubygems/defaults/#{RUBY_ENGINE}"
        rescue ::LoadError
        end
      end
    ensure
      $VERBOSE, $DEBUG = verbose, debug
    end

    module QuickLoader

      @loaded_full_rubygems_library = false

      def self.load_full_rubygems_library
        if $DEBUG || $VERBOSE
          $stderr.puts 'warning, loading full rubygems'
        end
        return if @loaded_full_rubygems_library

        @loaded_full_rubygems_library = true

        class << Gem
          undef_method(*Gem::GEM_PRELUDE_METHODS)
          undef_method :const_missing
          undef_method :method_missing
        end

        Kernel.module_eval do
          undef_method :gem if method_defined? :gem
        end

        $".delete path_to_full_rubygems_library
        path = nil
        if $".any? {|path| path =~ Regexp.new('/rubygems.rb$')}
          raise LoadError, "another rubygems is already loaded from #{path}"
        end
        require 'rubygems'
        begin
          require 'rubygems.rb.bak' # just in case
        rescue ::LoadError
          # ok
        end
      end

      def self.fake_rubygems_as_loaded
        path = path_to_full_rubygems_library
        $" << path unless $".include?(path)
      end

      def self.path_to_full_rubygems_library
        # null rubylibprefix may mean 'you have loaded the other rubygems already somehow...' hmm
        prefix = (RbConfig::CONFIG["rubylibprefix"] ||  RbConfig::CONFIG['rubylibdir'].split('/')[0..-2].join('/'))
        installed_path = File.join(prefix, Gem::ConfigMap[:ruby_version])
        if $:.include?(installed_path)
          return File.join(installed_path, 'rubygems.rb')
        else # e.g., on test-all
          $:.each do |dir|
            if File.exist?( path = File.join(dir, 'rubygems.rb') )
              return path
            end
          end
          raise LoadError, 'rubygems.rb'
        end
      end

      GemPaths = {}
      GemVersions = {}

      def push_gem_version_on_load_path(gem_name, *version_requirements)
        if version_requirements.empty?
          puts 'in push gemv2', GemPaths, gem_name
          unless path = GemPaths[(gem_name)] then
            puts "Could not find RubyGem #{gem_name} (>= 0)\n" if $VERBOSE || $DEBUG
            raise Gem::LoadError, "Could not find RubyGem #{gem_name} (>= 0)\n"
          end
          puts 'in push gemv3'
          # highest version gems *not* already active

          # copied and pasted...
                  require_paths = []

                  if File.exist?(file = File.join(path, ".require_paths")) then
                    paths = File.read(file).split.map do |require_path|
                      File.join path, require_path
                    end
                    
                    require_paths.concat paths
                  else
                    # bin shouldn't be necessary...
                    # require_paths << file if File.exist?(file = File.join(path, "bin"))
                    require_paths << file if File.exist?(file = File.join(path, "lib"))
                  end

                    # "tag" the first require_path inserted into the $LOAD_PATH to enable
                    # indexing correctly with rubygems proper when it inserts an explicitly
                    # gem version
                    unless require_paths.empty? then
                      require_paths.first.instance_variable_set(:@gem_prelude_index, true)
                    end
                    # gem directories must come after -I and ENV['RUBYLIB']
                    $:[$:.find{|e|e.instance_variable_defined?(:@gem_prelude_index)}||-1,0] = require_paths
          
          return false
        else
          if version_requirements.length > 1 then
            QuickLoader.load_full_rubygems_library
            return gem(gem_name, *version_requirements)
          end

          requirement, version = version_requirements[0].split
          requirement.strip!

          if loaded_version = GemVersions[gem_name] then
            case requirement
            when ">", ">=" then
              return false if
                (loaded_version <=> Gem.integers_for(version)) >= 0
            when "~>" then
              required_version = Gem.integers_for version

              return false if loaded_version.first == required_version.first
            end
          end

          QuickLoader.load_full_rubygems_library
          gem gem_name, *version_requirements
        end
      end

      def integers_for(gem_version)
        numbers = gem_version.split(".").collect {|n| n.to_i}
        numbers.pop while numbers.last == 0
        numbers << 0 if numbers.empty?
        numbers
      end

      def calculate_all_highest_version_gems
        Gem.path.each do |path|
          gems_directory = File.join(path, "gems")

          if File.exist?(gems_directory) then
            Dir.entries(gems_directory).each do |gem_directory_name|
              next if gem_directory_name == "." || gem_directory_name == ".."

              next unless gem_name = gem_directory_name[/(.*)-(.*)/, 1]
              new_version = integers_for($2)
              current_version = GemVersions[gem_name]

              if !current_version or (current_version <=> new_version) < 0 then
                GemVersions[gem_name] = new_version
                GemPaths[gem_name] = File.join(gems_directory, gem_directory_name)
              end
            end
          end
        end
        return # early
        require_paths = []

        GemPaths.each_value do |path|
          if File.exist?(file = File.join(path, ".require_paths")) then
            paths = File.read(file).split.map do |require_path|
              File.join path, require_path
            end

            require_paths.concat paths
          else
          # bin shouldn't be necessary...
          # require_paths << file if File.exist?(file = File.join(path, "bin"))
            require_paths << file if File.exist?(file = File.join(path, "lib"))
          end
        end

        # "tag" the first require_path inserted into the $LOAD_PATH to enable
        # indexing correctly with rubygems proper when it inserts an explicitly
        # gem version
        unless require_paths.empty? then
          require_paths.first.instance_variable_set(:@gem_prelude_index, true)
        end
        # gem directories must come after -I and ENV['RUBYLIB']
        $:[$:.find{|e|e.instance_variable_defined?(:@gem_prelude_index)}||-1,0] = require_paths
      end
      
      def const_missing(constant)
        puts 'consta missing', constant, 'caller is',caller
        QuickLoader.load_full_rubygems_library

        if Gem.const_defined?(constant) then
          Gem.const_get constant
        else
          super
        end
      end
      
      def method_missing(method, *args, &block)
        QuickLoader.load_full_rubygems_library
        super unless Gem.respond_to?(method)
        Gem.send(method, *args, &block)
      end
      
    end

    extend QuickLoader

  end

  Gem.calculate_all_highest_version_gems
  # use cached load instead of loading lib paths into the load path here
  require File.expand_path(File.dirname(__FILE__)) + "/prelude_cached_load"

end

