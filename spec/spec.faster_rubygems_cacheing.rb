# to test in 1.8.x, make sure to use ruby specname.rb
require File.dirname(__FILE__) + "/../lib/faster_rubygems"
require 'sane'
require 'spec/autorun'
require 'fileutils'

describe Gem do

  before do
    ENV['GEM_PATH'] = 'test_dir'
    @gem_path = 'test_dir/gems/' # wow.
    FileUtils.rm_rf @gem_path
    FileUtils.mkdir_p @gem_path
  end

  context "speeding Gem.bin_path the fake sick way" do

    it "should fake guess the right path instead of loading full rubygems for now" do
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
