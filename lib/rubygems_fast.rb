if RUBY_VERSION < '1.9'
  require 'rbconfig'

  gem_paths = []
  gem_paths << Config::CONFIG['libdir'] + '/ruby/gems/' + RUBY_VERSION[0..2] + '/gems'

  # handle ~/.gem
  gem_paths << File.expand_path('~') + '/.gem/ruby/' + RUBY_VERSION[0..2] + '/gems'

  # handle ENV['GEM_PATH'] if it exists
  gem_paths << ENV['GEM_PATH'].split(':').select{|path| path + '/.gems'} if ENV['GEM_PATH'] # TODO should this override or supplement?

  # TODO
  # spec: should find highest version of files
  # spec: with multiple paths should find all files :P

  all_gems = []

  for gem_path in gem_paths.flatten do

    all_gems << Dir.glob(gem_path + '/*')

  end
  all_gems.flatten!.sort!.reverse!

  already_loaded_gems = {}

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
        $: << gem + '/lib'
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
else
 # not needed in 1.9, which by default loads gem_prelude
end
