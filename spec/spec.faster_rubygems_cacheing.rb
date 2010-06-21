# this is going to be hard to test in 1.8.x...
# maybe use faster_rubygems itself, to load the tests?

require File.dirname(__FILE__) + '/common.rb'

describe FasterRubyGems do

  before do
    setup    
  end

  context "speeding Gem.bin_path the fake sick way" do

    it "should fake guess the right path instead of loading full rubygems for now" do
      new_path = __dir__ + "/gems/after-0.7.0/bin"
      $:.unshift new_path
      Gem.bin_path('after', 'after', ">= 0").should == new_path + '/after'
      # should not have loaded full gems...
      # if this line fails then make sure you are running the spec file like ruby xxx not spec xxx
      assert !defined?(Gem::Dependency)
    end
    
    it "should load full rubygems to get the original value to cache" # lower prio
    
  end
  
  context "respecting gem xxx, yyy commands" do

    it "should do nothing if you pass it a default version, which is *oh so right*" do
      # typical binary script:
      # gem 'after', ">= 0"
    
      length = $:.length
      gem 'after', ">= 0"
      # should have been a no op
      assert $:.length == length
      assert !defined?(Gem::Dependency)
    end
    
    it "should do nothing if you pass a version that is 'the one version already on the load path'" do
      fail
    end
    
    it "should react if you use --disable-gems in 1.9"
    
    # rest are lower prio

    it "should load a cached path to $:"
    
    it "should load several cached paths to $:"
    
    it "should load full rubygems to get the original values to cache"
    
    it "should actually activate each previous when it is forced to load full rubygems later"
  
    it "should fail if you active a gem once, then another version"
    
    it "should do what 1.9 does not do and fail if you implicitly activate, then really activate" 
  end
  
  it "should clear the cache on Gem change"
  
  it "should use a different cache based on different gem config and ruby version"
  
end