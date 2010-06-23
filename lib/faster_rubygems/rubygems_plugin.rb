
Gem.post_install { |gem_installer_instance|
  require File.dirname(__FILE__) + "/prelude_create_cache"
  Gem.create_cache_for_all!  
}

Gem.post_uninstall {
  require File.dirname(__FILE__) + "/prelude_create_cache"
  Gem.create_cache_for_all!  
}