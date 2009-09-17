require 'fileutils'
require 'rbconfig'

dir = File.dirname(__FILE__)
for file in ['rubygems_fast.rb', 'frubygems.rb'] do
  FileUtils.cp dir + '/' + file, Config::CONFIG['sitelibdir'] + '/' + file
end

require 'frubygems' # test it out now :P

puts 'Installed--thank you for trying out -- require \'frubygems\''
