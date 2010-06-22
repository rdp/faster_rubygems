require File.dirname(__FILE__) + "/../lib/faster_rubygems"
require File.dirname(__FILE__) + "/../lib/faster_rubygems/cache"
require 'sane'
require 'rspec' # rspec 2
require 'fileutils'

describe 'can create cache file apropo' do
  before do
    FileUtils.rm_rf Dir['test_dir/gems/*']
  end
  
  def create name, version = '0.0.0'
    new_name ='test_dir/gems/' + name  + "-" + version
    FileUtils.mkdir_p new_name + '/lib'
    File.write new_name + '/lib/a_file.rb', 'cool rubyness'
  end
  
  it 'should be able to create a file' do
    create 'gem1'
    Gem.create_cache ['test_dir']
    assert File.exist?('test_dir/.faster_rubygems_cache')
  end
  
  it 'should be bigger with more gems' do
    create 'gem1'
    Gem.create_cache ['test_dir']
    size = File.size('test_dir/.faster_rubygems_cache')
    create 'gem2'
    Gem.create_cache ['test_dir']
    size2 = File.size('test_dir/.faster_rubygems_cache')
    assert size2 > size
  end
  
  it 'should be same size if two versions, same gem' do
    create 'gem1'
    Gem.create_cache ['test_dir']
    size = File.size('test_dir/.faster_rubygems_cache')
    create 'gem1', '0.0.1'    
    Gem.create_cache ['test_dir']
    size2 = File.size('test_dir/.faster_rubygems_cache')
    assert size2 == size
  end  
  
  
end