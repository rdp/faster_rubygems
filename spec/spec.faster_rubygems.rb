require 'rubygems' if RUBY_VERSION[0..2] < '1.9'
require 'sane'
require_relative '../lib/faster_rubygems_lib'
require 'spec/autorun'
require 'fileutils'
    
describe FasterRubyGems do

  before do
    ENV['GEM_PATH'] = 'test_dir'
    @gem_path = 'test_dir/gems/' # boo
    FileUtils.rm_rf @gem_path
    raise 'you dont need to test this on 1.9' if RUBY_VERSION > '1.9'
  end
  
  it "should calculate something" do
    paths = FasterRubyGems.gem_prelude_paths
    assert paths.length == 0
    FileUtils.mkdir_p @gem_path + '/abc-0.9.0/lib'
    paths = FasterRubyGems.gem_prelude_paths
    assert paths.length == 1    
  end
  
  it "should calculate 0.10.0 as greater than 0.9.0" do
    
    FileUtils.mkdir_p @gem_path + '/abc-0.9.0/lib'
    FileUtils.mkdir_p @gem_path + '/abc-0.10.0/lib'
    paths = FasterRubyGems.gem_prelude_paths
    assert( (paths.grep /abc-0.10.0/).length > 0)
  end
  
  it "should find highest version of normal numbered gems" do
    FileUtils.mkdir_p @gem_path + '/abc-0.8.0/lib'
    FileUtils.mkdir_p @gem_path + '/abc-0.9.0/lib'
    paths = FasterRubyGems.gem_prelude_paths
    assert( (paths.grep /abc-0.9.0/).length > 0)    
  end
  
  it "with multiple paths should find all files"
  
  it "should respect file::separator"
  
  
  def ruby lib
    assert system(OS.ruby_bin + ' ' + lib)
    assert system(OS.ruby_bin + ' ' + lib)
  end
  
  it "should load full rubygems on gem xxx" do
    ruby('files/test_gem.rb')
    ruby('files/test_gem_const.rb')
     ruby('files/test_gem_func.rb')
  end

end