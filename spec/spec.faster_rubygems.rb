# to test in 1.8.x, make sure to use ruby specname.rb
require File.dirname(__FILE__) + "/../lib/faster_rubygems"
require 'sane'
require 'spec' # rspec 1
require 'spec/autorun'
require 'fileutils'
raise if ENV['RUBYOPT']

describe Gem do

  before do
    ENV['GEM_PATH'] = 'test_dir'
    @gem_path = 'test_dir/gems/' # wow.
    FileUtils.rm_rf @gem_path
    FileUtils.mkdir_p @gem_path
  end

  context "speeding Gem.bin_path by inferring" do

    it "should fake guess the right path instead of loading full rubygems for now" do
      assert Gem.bin_path('after', 'after', ">= 0") =~ /after.*bin.*after/
      # should not have loaded full gems...
      # if this line fails then make sure you are running the spec file like ruby xxx not spec xxx
      assert !defined?(Gem::Dependency)
    end

  end

  it "should pass test files" do
    Dir['files/*'].each{|f|
      raise f unless system(OS.ruby_bin + " #{f}")
    }
  end
  
  context "gem xxx" do
    it "should allow you to load 'older' gem versions somehow, like maybe cacheing" # lower prio
  end
  
  it "in 1.9 if you pass it --disable-gems, it should load its full gem_prelude right there...I guess...though that's not going to fix any bottlenecks though..."

  it "should make a directory cacheing list (yes!) in the root of each gem and load that, and use that to activate. Oh baby. Maybe, though that might fall
  more under the faster_require aspect of it...hmm...maybe it's fast enough for now, except rails, which needs faster_require no matter what anyway..."
  
end