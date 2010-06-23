require 'fileutils'
require 'rbconfig'

Dir.chdir File.dirname(__FILE__) + '/lib' do
  for file in Dir['*'] do
    FileUtils.cp_r file, Config::CONFIG['sitelibdir'] + '/' + file
  end
end

puts 'Installed--thank you for trying out -- require \'faster_rubygems\''
