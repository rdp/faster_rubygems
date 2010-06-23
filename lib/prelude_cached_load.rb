require File.dirname(__FILE__) + '/ir_session'

module Gem
    module QuickLoader
      module PreludeRequire
        def require_prelude lib
          begin
            require_pre_prelude lib
          rescue ::LoadError => e
            PreludeRequire.push_all_gems_that_might_match_and_reload_files lib, e
            require_pre_prelude lib
          end
        end
        
        def self.push_all_gems_that_might_match_and_reload_files lib, error
          puts Gem.path
          @all_lists ||= Gem.path.map{|path|
            cache_name = path + '/.faster_rubygems_cache'
            puts cache_name
            if File.exist?(cache_name)
              [path, Marshal.load(File.open(cache_name))]
            else
              puts 'cache file does not exist! unexpected!' + cache_name
              nil
            end
            }.compact
#          repl(binding)
          sub_lib = lib.gsub("\\", '/').split('/')[-1]
          sub_lib = Regexp.new(sub_lib)
          success = false
          @all_lists.each{|path, gem_list|
            for gem_name, long_file_list in gem_list 
              if long_file_list =~ sub_lib
                puts 'hit', gem_name
                success = true
                gem gem_name
              end
              
            end
          }
          puts 'non hit'
          if success
            require lib
          else
            # re-raise
            raise error
          end
          
        end
        
      end
    end
  end
  
  module Kernel
    include Gem::QuickLoader::PreludeRequire
    alias :require_pre_prelude :require
    alias :require :require_prelude
  end

  begin
    Gem::QuickLoader.fake_rubygems_as_loaded
    puts 'I faked it loaded--I did'
  rescue Exception => e
    puts "Error cached require startup"
    puts e
    puts e.backtrace.join("\n")
  end

