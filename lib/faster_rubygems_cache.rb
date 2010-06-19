if RUBY_VERSION < '1.9.0'
  
  module Kernel
    
    def gem(gem_name, *version_requirements)
      if(version_requirements == [">= 0"])
         # basically a no-op because it's already on the load path
         if $:.detect{|p| p =~ Regexp.new('gems/' + gem_name)}
            return
         else
           $stderr.puts 'faster_rubygems_gem gem not found' + gem_name
         end
      else
        $stderr.puts 'faster_rubygems_gem gem command has requirements--please remove for faster_rubygems to work at its speediest ' + caller.join("\n")
      end

      undef :gem # necessary?
      require 'rubygems' # punt!
      Gem::Dependency # punt 1.9!      
      gem *args
    end
  end
  
  module Gem
    def self.const_missing const
      require 'rubygems' # punt!
      return Gem.const_get(const)
    end
  
    def self.method_missing meth, *args
     require 'rubygems' # punt!
     return Gem.send(meth, *args)
    end
  end

end

module Gem

  module FasterCache
    def self.cache_dir=new_cache
      @cache_dir = new_cache + '/'
      Dir.mkdir new_cache unless File.directory?(new_cache)
    end
    
    # set it to its default
    self.cache_dir=File.expand_path('~/.faster_rubygems')
    
    def self.cache_dir
      @cache_dir
    end
  end
  
  
  def self.bin_path(name, exec_name = null, *version_args)
    # version_args are very very very typically [">= 0"]
    path = $:.detect{|n| n =~ Regexp.new("gems/" + name + "-.*bin")}
    if path && exec_name && version_args == [">= 0"]
      path + '/' + exec_name
    else
      $stderr.puts 'warning, faster_rubygems_bin_path unable to find',name,exec_name
      require 'rubygems' # punt 1.8!
      Gem::Dependency    # punt 1.9!
      Gem.bin_path(name, exec_name, *version_args)
    end
  end
  
end