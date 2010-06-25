Gem.post_install { |gem_installer_instance|
  require "faster_rubygems/create_cache_for_all"
}

Gem.post_uninstall {
  require "faster_rubygems/create_cache_for_all"
}