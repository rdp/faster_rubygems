require File.dirname(__FILE__) + "/../lib/faster_rubygems"
require File.dirname(__FILE__) + "/../lib/faster_rubygems/prelude_create_cache"
require 'sane'
begin
  require 'rspec' # rspec 2
rescue LoadError
  require 'spec/autorun'
end
require 'fileutils'
raise if ENV['RUBYOPT'] # avoid silly testing conflicts
require 'rbconfig'

describe 'can create cache file apropo' do
  before do
    @ruby_ver = RbConfig::CONFIG['ruby_version']
    @gem_dir = 'test_dir/gems/' + @ruby_ver
    @gem_dir_cache = @gem_dir + '/.faster_rubygems_cache'
    clean
    create_gem 'gem1'
    cache!
  end
  
  def clean
    FileUtils.rm_rf Dir['test_dir/gems/*']
    FileUtils.rm_rf Dir['test_dir/.faster*']  
    FileUtils.rm_rf 'test_file.rb'
  end
  
  after do
    clean
  end
  
  private
  
  def create_gem name, version = '0.0.0'
    new_name = @gem_dir + '/gems/' + name  + "-" + version
    FileUtils.mkdir_p new_name + '/lib'
    File.write new_name + '/lib/a_file.rb', name.upcase + '= "abc"'
  end
  
  def cache!
    Gem.create_cache [@gem_dir]
  end
  
  it 'should be able to create a cache file' do
    assert File.exist?(@gem_dir_cache)
  end
  
  it 'should be bigger with more gems' do
    size = File.size(@gem_dir_cache)
    create_gem 'gem2'
    cache!
    size2 = File.size(@gem_dir_cache)
    assert size2 > size
  end
  
  it 'should be same size if two versions, same gem' do
    size = File.size(@gem_dir_cache)
    create_gem 'gem1', '0.0.1'    
    cache!
    size2 = File.size(@gem_dir_cache)
    assert size2 == size
  end
  
  it "should cache the version numbers of gems, too" do
    Marshal.load(File.open(@gem_dir_cache)).to_s.should_not include "0.0.0"
  end
  
  it "should create two caches if you pass it two dirs" do
    Dir['**/.faster_rubygems_cache'].length.should == 1
    gem_dir2 = 'test_dir2/gems/' + @ruby_ver
    FileUtils.mkdir_p gem_dir2
    Gem.create_cache [@gem_dir, gem_dir2]
    Dir['**/.faster_rubygems_cache'].length.should == 2
    FileUtils.rm_rf 'test_dir2'
  end
  
  def create_file use_gem
    all = <<-EOS
      ENV['GEM_PATH'] = 'test_dir/gems/#{@ruby_ver}'
      require File.dirname(__FILE__) + '/../lib/faster_rubygems'
      #{use_gem ? "gem 'gem1'" : nil}
      require 'a_file'
      unless defined?(GEM1)
        puts 'GEM1 not defined'
        exit 1
      end
      if defined?(Gem::Dependency)
        puts 'Gem::Dependency defined'
        exit 1
      end
    EOS
    File.write 'test_file.rb', all
    if RUBY_VERSION >= '1.9.0'
      assert system(OS.ruby_bin + " --disable-gems test_file.rb")
    else
      assert system(OS.ruby_bin + " test_file.rb")
    end
  end
  
  it "should not load full rubygems--load the cache files instead" do
    create_file false
  end

  it "should work with the gem 'xxx' command" do
    create_file true
  end
  
  it 'should work with capitalized like RMagick -> Magick'
  
  it "should create the caches on install/uninstall" do
    FileUtils.rm_rf Gem.path[0] + "/.faster_rubygems_cache"
    Gem.create_cache_for_all! 
    assert File.exist?(Gem.path[0] + "/.faster_rubygems_cache")
    puts Gem.path[0] + "/.faster_rubygems_cache"
  end
  
  it "should not cause a cyclic require that just calls and fails, calls and fails"
  
  it "should use that phreaky marker well (set it, et al)"
  
  it "should be ok if certain .paths aren't writable"
  
  it "should revert to full load of all paths into $: in the case of missing cache files"
  
end