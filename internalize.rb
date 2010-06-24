require 'fileutils'
require 'rbconfig'

Dir.chdir File.dirname(__FILE__) + '/lib' do
  for file in Dir['*'] do
    new_file = Config::CONFIG['sitelibdir'] + '/' + file
    FileUtils.rm_rf new_file if File.exist?(new_file)
    FileUtils.cp_r file, new_file
  end
end

puts 'Installed--thank you for trying out faster_rubygems' # they never see this message tho...