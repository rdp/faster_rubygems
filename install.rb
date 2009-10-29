require 'fileutils'
require 'rbconfig'

Dir.chdir 'lib' do
  for file in Dir['*.rb'] do
    FileUtils.cp file, Config::CONFIG['sitelibdir'] + '/' + file
  end
end

require 'frubygems' # test it out now :P

puts 'Installed--thank you for trying out -- require \'frubygems\''
