require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sane'
require_relative '../lib/faster_rubygems'
require 'spec/autorun'
require 'fileutils'

def setup
    ENV['GEM_PATH'] = 'test_dir'
    @gem_path = 'test_dir/gems/' # wow.
    FileUtils.rm_rf @gem_path
    FileUtils.mkdir_p @gem_path
end
