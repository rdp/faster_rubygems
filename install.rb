require 'fileutils'
require 'rbconfig'

Dir.chdir File.dirname(__FILE__) + '/lib' do
  for file in Dir['*.rb'] do
    FileUtils.cp file, Config::CONFIG['sitelibdir'] + '/' + file
  end
end

require 'frubygems' # test it out now, to make sure it worked (doesn't seem to hurt anything...)

puts 'Installed--thank you for trying out -- require \'faster_rubygems\''
