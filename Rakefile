require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{faster_rubygems}

  s.summary = %q{faster gem loading}
  s.extensions = ["ext/mkrf_conf.rb"]

  s.post_install_message = "

installed! 1.9 use -> require 'faster_rubygems' 

1.8: use require 'faster_rubygems' or install as the default thus:

>> require 'rubygems'
>> require 'faster_rubygems/install'
"
  s.add_development_dependency 'test-unit', '=1.2.3'
  s.add_development_dependency 'test-unit', '=2.0.6'
  s.add_development_dependency 'after', '=0.7.0'
  s.add_development_dependency 'sane'
  s.add_dependency 'faster_require'

end