# this is going to be hard to test in 1.8.x...
# maybe use faster_rubygems itself, to load the tests?

require File.dirname(__FILE__) + '/common.rb'

describe Gem do

  before do
    setup    
  end

  context "speeding Gem.bin_path the fake sick way" do

    it "should fake guess the right path instead of loading full rubygems for now" do
      require 'ruby-debug'
      debugger
      assert Gem.bin_path('after', 'after', ">= 0") =~ /after.*bin.*after/
      # should not have loaded full gems...
      # if this line fails then make sure you are running the spec file like ruby xxx not spec xxx
      assert !defined?(Gem::Dependency)
    end
    
  end
  
  context "gem xxx" do
    it "should allow you to load 'older' gem versions somehow, like maybe cacheing" # lower prio
  end    

  
end