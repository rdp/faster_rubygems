module Gem
    module QuickLoader
      module PreludeRequire
        def require_prelude lib          
          begin
            require_pre_prelude lib
          rescue ::LoadError => e
            if Gem.push_all_gems_that_might_match_and_reload_files(lib, e)
              require_pre_prelude lib
            else
              # re-raise
              raise e
            end
          end
        end
      end
      
      def push_all_gems_that_might_match_and_reload_files lib, error
        sub_lib = lib.gsub("\\", '/').split('/')[-1].split('.')[0]
        success = false
        raise if AllCaches.empty? # should never be empty...
        AllCaches.each{|path, gem_list|
          for gem_name, long_file_list in gem_list 
            if long_file_list[sub_lib.downcase]
              puts 'activating' + gem_name + ' ' + sub_lib.to_s if $DEBUG
              if gem(gem_name)
                puts 'gem activated ' + gem_name + ' ' + sub_lib if $VERBOSE || $DEBUG
                success = true
              end
              puts 'done activeating' + gem_name + ' ' + sub_lib if $DEBUG
            end
            
          end
        }
        success
      end
      
    end
  end
  
  module Kernel
    include Gem::QuickLoader::PreludeRequire
    alias :require_pre_prelude :require
    alias :require :require_prelude
  end

