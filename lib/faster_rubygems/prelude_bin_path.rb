module Gem

  module QuickLoader
    def bin_path(gem_name, exec_name = nil, *version_requirements)
      unless GemPaths.has_key?(gem_name) then
        raise Gem::LoadError, "Could not find RubyGem #{gem_name} (>= 0)\n"
      end

      version_match = false
      if version_requirements.empty?
        version_match = true
      else
        if version_requirements.length > 1 then
          version_match = false
        else

          requirement, version = version_requirements[0].split
          requirement.strip!

          if loaded_version = GemVersions[gem_name] then
            case requirement
            when ">", ">=" then
              if  (loaded_version <=> Gem.integers_for(version)) >= 0
                version_match = true
              end
            when "~>" then
              required_version = Gem.integers_for version

              if loaded_version.first == required_version.first
                version_match = true
              end
            end
          end
        end
      end

      if version_match && exec_name
        full_path = GemPaths[gem_name] + '/bin/' + exec_name
        if File.exist? full_path
          return full_path
        end
      end
      QuickLoader.load_full_rubygems_library
      bin_path(gem_name, exec_name, *version_requirements)
    end

    # 1.9.1's gem_prelude doesn't seem to have this for some reason...
    def integers_for(gem_version)
        numbers = gem_version.split(".").collect {|n| n.to_i}
        numbers.pop while numbers.last == 0
        numbers << 0 if numbers.empty?
        numbers
    end unless Gem.respond_to?(:integers_for)
    
  end
  
  extend QuickLoader

end