module Gem
  module QuickLoader
    def create_cache gem_paths
      gem_paths.each do |path|
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
        gem_paths.each{|k, v| gem_paths_with_contents[k] = Dir[v + '/**/*'].select{|f| !File.directory? f}.map{|fn| fn.sub(v + '/', '')}.join(' ')}
        File.open(path + '/.faster_rubygems_cache', 'w') do |f|
          f.write Marshal.dump gem_paths_with_contents
        end
        puts gem_paths_with_contents
      end


    end

  end
end
