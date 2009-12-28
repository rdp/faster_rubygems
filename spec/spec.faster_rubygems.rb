require 'sane'
require_rel '../lib/faster_rubygems_lib'
require 'spec/autorun'
require 'fileutils'
    
describe FasterRubygems do

  it "should calculate something" do
    paths = FasterRubygems.gem_prelude_paths
    assert paths.length > 0
  end
  
  it "should calculate 0.10.0 as greater than 0.9.0" do
    ENV['GEM_PATH'] = 'test_dir'
    gem_path = 'test_dir/gems/' # boo
    FileUtils.mkdir_p gem_path + '/abc-0.9.0/lib'
    FileUtils.mkdir_p gem_path + '/abc-0.10.0/lib'
    _dbg
    paths = FasterRubygems.gem_prelude_paths
    assert( (paths.grep /abc-0.10.0/).length > 0)
    
  end
  
  it "should find highest version of files"
  it "with multiple paths should find all files"


end