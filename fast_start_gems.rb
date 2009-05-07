require 'rbconfig'

gems = Config::CONFIG['libdir'] + '/ruby/gems/' + RUBY_VERSION[0..2] + '/gems/*'
all_gems = Dir.glob(gems).sort.reverse
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
