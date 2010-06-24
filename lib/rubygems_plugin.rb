Gem.post_install { |gem_installer_instance|
  require File.dirname(__FILE__) + "/create_cache_for_all"
}

Gem.post_uninstall {
  require File.dirname(__FILE__) + "/create_cache_for_all"
}