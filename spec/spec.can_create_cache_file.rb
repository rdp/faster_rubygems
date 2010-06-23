require File.dirname(__FILE__) + "/../lib/faster_rubygems"
require File.dirname(__FILE__) + "/../lib/faster_rubygems/cache"
require 'sane'
require 'rspec' # rspec 2
require 'fileutils'

describe 'can create cache file apropo' do
  before do
    FileUtils.rm_rf Dir['test_dir/gems/*']
    FileUtils.rm_rf Dir['test_dir/.faster*']
  end
  
  private
  
  def create name, version = '0.0.0'
    new_name ='test_dir/gems/' + name  + "-" + version
    FileUtils.mkdir_p new_name + '/lib'
    File.write new_name + '/lib/a_file.rb', 'cool rubyness'
  end
  
  it 'should be able to create a cache file' do
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
  
  it "should create two caches if you pass it two dirs" do
    create 'gem1'
    FileUtils.mkdir_p 'test_dir2/gems'
    Gem.create_cache ['test_dir', 'test_dir2']
    Dir['**/.faster_rubygems_cache'].length.should == 2
    FileUtils.rm_rf 'test_dir2'
  end
  
  
  it "should create the caches on install/uninstall"
  
  it "should be ok if you aren't writable"
  
  it "should not load full rubygems--load the cache files instead"
  
  it "should revert to full load in the case of missing cache files"
  
  
end