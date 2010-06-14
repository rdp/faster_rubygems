class FasterRubyGems
  
  def self.all_gem_roots
    gem_paths = []
    # add the default gem path
     
    gem_paths << Config::CONFIG['libdir'] + '/ruby/gems/' + RUBY_VERSION[0..2] + '/gems'

    # add ~/.gem
    gem_paths << File.expand_path('~') + '/.gem/ruby/' + RUBY_VERSION[0..2] + '/gems'

    # add ENV['GEM_PATH'] if it exists
    if ENV['GEM_PATH']
      gem_paths = ENV['GEM_PATH'].split(File::PATH_SEPARATOR).collect{|path| path + '/gems'} 
    end
    # ... should probably have more here ...
    gem_paths.flatten
  end
  
  def self.gem_prelude_paths
    raise 'only 1.8 wants this' if RUBY_VERSION[0..2] > '1.8'
    require 'rbconfig'    
  
    all_gems = []
    for gem_path in all_gem_roots do
      all_gems << Dir.glob(gem_path + '/*')
    end
    all_gems.flatten!
    all_gems = all_gems.sort_by{|gem| gem.split('-')[-1].split('.').map{|n| n.to_i}} # 0.10.0 > 0.9.0 so sort it thus
    all_gems.reverse!

    already_loaded_gems = {}

    prelude_paths = []

    for gem in all_gems do

      version = gem.split('-')[-1]
      if version =~ /\d+\.\d+\.\d+/
        name = gem.split('-')[0..-2]
      else
        gem =~ /(.*)(\d+\.\d+\.\d+).*$/ # like abc-1.2.3-mswin32-60 or what not
        version = $2
        name = $1
        next unless version # a few oddities like rbfind-1.1
      end

      if(!already_loaded_gems[name])
        already_loaded_gems[name] = true
        if File.directory? gem + '/lib'
          prelude_paths << gem + '/lib'
        else
          # unfortunately a few gems load from, say gem/something_not_lib/gemname.rb
          for dir in Dir.glob(gem + '/*') do
            if File.directory? dir
              $: << dir
              # if anybody wants anything lower than that, let me know
            end
          end
        end
      end

    end
    prelude_paths
  end
end