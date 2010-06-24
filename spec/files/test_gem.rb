require File.dirname(__FILE__) + '/../../lib/faster_rubygems'
gem 'test-unit', '= 1.2.3'
require 'test/unit/version'
raise 'bad version' unless Test::Unit::VERSION == '1.2.3'