begin
 require 'ftools'
rescue LoadError
 # not there on 1.9
end

require 'rbconfig'
dir = File.dirname(__FILE__)
for file in ['rubygems_fast.rb', 'rubygems_f.rb'] do
  File.copy dir + '/' + file, Config::CONFIG['sitelibdir']
end

require 'rubygems_f' # test it out :P

puts 'Installed--thank you for trying out require \'rubygems_f\''
