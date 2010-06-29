require File.dirname(__FILE__) + "/prelude_bin_path" # Gem.integers_for, for 1.9.1

module Gem
  module QuickLoader
    def create_cache gems_paths
      puts 'faster_rubygems: creating all caches'
      gems_paths.each do |path|
        gem_versions = {}
        gem_paths = {}
        gems_directory = File.join(path, "gems")
        if File.exist?(gems_directory) then
          Dir.entries(gems_directory).each do |gem_directory_name|
            next if gem_directory_name == "." || gem_directory_name == ".."

            next unless gem_name = gem_directory_name[/(.*)-(.*)/, 1]
            new_version = integers_for($2)
            current_version = gem_versions[gem_name]

            if !current_version or (current_version <=> new_version) < 0 then
              gem_versions[gem_name] = new_version
              gem_paths[gem_name] = File.join(gems_directory, gem_directory_name)
            end
          end
        end
        gem_paths_with_contents = {}
        # strip out directories, and the gem-d.d.d prefix
        gem_paths.each{|k, v| 
          
          files = Dir[v + '/**/*.{rb,so,bundle}'].select{|f| 
            !File.directory? f
          }.map{ |full_name| 
            full_name.sub(v + '/', '')
            full_name.split('/')[-1].split('.')[0] # just a of a.b.c.rb, for now
          }
          
          hash_of_files = {}
          files.each{|small_filename|
            hash_of_files[small_filename] = true
          }
          gem_paths_with_contents[k] = hash_of_files
        }
        
        cache_path = path + '/.faster_rubygems_cache'
        print '.'
        puts cache_path if $VERBOSE
        $stdout.flush
        # accomodate for those not running as sudo...
        if File.writable? path
          File.open(cache_path, 'wb') do |f|
            f.write Marshal.dump(gem_paths_with_contents)            
          end
        else
          $stderr.puts "warning, unable to write cache to:" + cache_path
        end
      end

    end
    
    def create_cache_for_all!
      puts 'recreating all faster_rubygems caches'
      create_cache Gem.path
    end
    
  end
extend QuickLoader
end
