require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{faster_rubygems}

  s.summary = %q{faster gem loading}
  s.extensions = ["ext/mkrf_conf.rb"]

  s.post_install_message = "

faster_rubygems installed into your site_ruby directory.

If you're on 1.9 please set your RUBYOPT env. variable thus, to use it:

$ export RUBYOPT=--disable-gems -rfaster_rubygems

or (windows)

C:\>set RUBYOPT=--disable-gems -rfaster_rubygems

"
  s.add_development_dependency 'test-unit', '=1.2.3'
  s.add_development_dependency 'test-unit', '=2.0.6'
  s.add_development_dependency 'after', '=0.7.0'
  s.add_development_dependency 'sane'
  s.add_development_dependency 'rspec', '>=2.0.0'
#  s.add_dependency 'faster_require'

end