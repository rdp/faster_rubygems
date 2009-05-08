require 'rbconfig'

gem_paths = []

gem_paths << Config::CONFIG['libdir'] + '/ruby/gems/' + RUBY_VERSION[0..2] + '/gems'
gem_paths << ENV['GEM_PATH'].split(':') if ENV['GEM_PATH'] # TODO should this override or supplement?

# spec: should find highest version of files
# spec: with multiple paths should find all files :P

gem_paths << File.expand_path('~')
all_gems = []

for gem_path in gem_paths do

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
    $: << gem + '/lib'
  end
    
end
