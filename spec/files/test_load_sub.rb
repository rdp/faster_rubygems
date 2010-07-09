raise if ENV['RUBYOPT']
require File.dirname(__FILE__) + '/../../lib/faster_rubygems'
require 'rspec/expectations' # rspec 2 gem necessary, unfortunately