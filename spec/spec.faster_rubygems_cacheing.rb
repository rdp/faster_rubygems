# this is going to be hard to test in 1.8.x...
# maybe use faster_rubygems itself, to load the tests?

require File.dirname(__FILE__) + '/common.rb'

describe FasterRubyGems do

  before do
    setup    
  end

  it "should default to $HOME" do
    Gem::FasterCache.cache_dir.should == File.expand_path('~/.faster_rubygems') + '/'
  end

  it "should have a changeable cache dir" do
    Gem::FasterCache.cache_dir = 'temp_cache_dir'
    Gem::FasterCache.cache_dir = 'temp_cache_dir' # run it twice so it will sniff out re-creation bugs
    Gem::FasterCache.cache_dir.should == 'temp_cache_dir/'
  end
  
  context "speeding Gem.bin_path the fake sick way" do

    it "should fake guess the right path instead of loading full rubygems for now" do
      new_path = __dir__ + "/gems/after-0.7.0/bin"
      $:.unshift new_path
      Gem.bin_path('after', 'after', ">= 0").should == new_path + '/after'
      # should not have loaded full gems...
      # if this fails then run it using ruby xxx not rspec xxx
      assert !defined?(Gem::Dependency)
    end
    
    it "should load full rubygems to get the original value to cache" # lower prio
    
  end
  
  context "respecting gem xxx, yyy commands" do
    
    it "should load a cached path to $:" do
      fail
    end
    
    
    it "should load several cached paths to $:" do
      fail
    end
    
    it "should load full rubygems to get the original values to cache" do
      fail
    end

    # rest are lower prio
    
    it "should actually activate each previous when it is forced to load full rubygems later"
  
    it "should fail if you active a gem once, then another version"
    
    it "should do what 1.9 does not do and fail if you implicitly activate, then really activate" 
  end
  
  it "should clear the cache on Gem change" do
    fail
  end
  
  it "should use a different cache based on different gem config and ruby version"
  
end