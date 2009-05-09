begin
 require 'ftools'
rescue LoadError
 # not there on 1.9
end

require 'rbconfig'
for file in ['rubygems_fast.rb', 'rubygems_f.rb'] do
  File.copy file, Config::CONFIG['sitelibdir']
end

puts 'Thank you for trying out rubygems_f'
