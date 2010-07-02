# copied from 1.9.2

# in reality, this file will only be ever run via 1.8

# depends on: array.rb dir.rb env.rb file.rb hash.rb module.rb regexp.rb
# vim: filetype=ruby

# NOTICE: Ruby is during initialization here.
# * Encoding.default_external does not reflects -E.
# * Should not expect Encoding.default_internal.
# * Locale encoding is available.
if defined?(Gem) then
  start = Time.now if $VERBOSE
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
        puts 'faster_rubygems: loading full rubygems',caller if $VERBOSE
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
        if path = $".detect {|path2| path2 =~ Regexp.new('/rubygems.rb$')}
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

      GemsActivated = {}
      def push_gem_version_on_load_path(gem_name, *version_requirements)
        if version_requirements.empty?
          unless path = GemPaths[gem_name] then
            puts "Could not find RubyGem #{gem_name} (>= 0)\n" if $VERBOSE || $DEBUG
            raise Gem::LoadError, "Could not find RubyGem #{gem_name} (>= 0)\n"
          end
          # highest version gems *not* already active
          if !AllCaches.empty?
            # then we are using the caches, and the stuff isn't preloaded yet
            # copied and pasted...
                  require_paths = []
                  if GemsActivated[gem_name]
                    return false
                  else
                    GemsActivated[gem_name] = true
                  end
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
                   # TODO  puts $:.index{|e|e.instance_variable_defined?(:@gem_prelude_index)}
                   # $:[$:.index{|e|e.instance_variable_defined?(:@gem_prelude_index)}||-1,0] = require_paths
                    $:[0,0] = require_paths
                    return true
          end
          # normal flow when not using caches--it's already on the path
          return false
        else
          if version_requirements.length > 1 then
            QuickLoader.load_full_rubygems_library
            return gem(gem_name, *version_requirements)
          end

          requirement, version = version_requirements[0].split
          requirement.strip!
          # accomodate for gem 'xxx', '2.3.8'
          if !version
            version = requirement
            requirement = '='
          end

          if loaded_version = GemVersions[gem_name] then
            case requirement
            when ">", ">=", '=' then
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

      def calculate_all_highest_version_gems load_them_into_the_require_path
        start = Time.now if $VERBOSE
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
                GemPaths[gem_name] = File.join(gems_directory, gem_directory_name) # TODO lazy load these, too...why not?
              end
            end
          end
        end
        puts "faster_rubygems: took " + (Time.now - start).to_s + "s to scan the dirs for versions" if $VERBOSE
        # TODO don't require iterating over all these, since you can extrapolate them from the cache files...

        return unless load_them_into_the_require_path
        
        
        # load all lib dirs into $:...
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
        puts 'gem_prelude: const missing', constant if $VERBOSE || $DEBUG
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
      
      start_load = Time.now if $VERBOSE
       # if the gem dir doesn't exist, don't count it against us
      AllCaches = Gem.path.select{|path| File.exist?(path)}.map{|path|
         cache_name = path + '/.faster_rubygems_cache'
         if File.exist?(cache_name)
            File.open(cache_name, 'rb') do |f|
              [path, Marshal.load(f)]
            end
         else
           $stderr.puts 'faster_rubygems: a cache file does not exist! reverting to full load path ' + cache_name
           nil
         end
      }
      puts "faster_rubygems: took " + (Time.now - start_load).to_s + "s to load the cache files" if $VERBOSE
      
      # we will use a clear cache as an indication of "non success" loading caches
      if AllCaches.index(nil)
        AllCaches.clear 
      else
        # success
      end
      
    end

    extend QuickLoader

  end

  
  begin
    if !Gem::QuickLoader::AllCaches.empty?
      puts 'faster_rubygems using caches ' + Gem::QuickLoader::AllCaches.map{|fn, contents| fn + "/.faster_rubygems_cache"}.join(' ') if $VERBOSE
      Gem.calculate_all_highest_version_gems false
      # use cached loader instead of loading lib paths into the load path here (what prelude does by default)
      require File.expand_path(File.dirname(__FILE__)) + "/prelude_cached_load.rb"
    else
      puts 'faster_rubygems not using caches!' if $VERBOSE
      Gem.calculate_all_highest_version_gems true
    end
    Gem::QuickLoader.fake_rubygems_as_loaded # won't be needing that regardless
  rescue Exception => e
    puts "Error loading gem paths on load path in gem_prelude"
    puts e
    puts e.backtrace.join("\n")
  end
  puts "faster_rubygems total load time:" + (Time.now - start).to_s if $VERBOSE
end