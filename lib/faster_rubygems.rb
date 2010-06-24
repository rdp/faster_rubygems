# :stopdoc:

# don't load it if normal rubygems is already loaded

if !defined?(Gem::Dependency)
  if( (RUBY_VERSION < '1.9.0') || !defined?(Gem))    # we're either 1.8 or 1.9 with --disable-gems
    # define it so gem_prelude will execute...
    module Gem; 
    end 
    require File.expand_path(File.dirname(__FILE__)) + "/faster_rubygems/my_gem_prelude"
  else
    if RUBY_VERSION >= '1.9.0'
      puts 'warning: faster_rubygems: you loaded gem_prelude already so I cant speed that up' if $VERBOSE
    end
  end

  # both 1.8 and 1.9 want this one no matter what though though...
  require File.expand_path(File.dirname(__FILE__)) + "/faster_rubygems/prelude_bin_path"
  
else
  if $VERBOSE || $DEBUG
    puts 'warning: faster_rubygems unable to load because normal rubygems already loaded (which thing is expected in certain instances, like when running the gem command)'
  end
end

