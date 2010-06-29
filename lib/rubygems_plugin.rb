Gem.post_install {
  require "faster_rubygems/create_cache_for_all"
}

Gem.post_uninstall {
  require "faster_rubygems/create_cache_for_all"
}

Gem.pre_uninstall { |gem_installer_instance, gem_spec|
  
  if gem_installer_instance.spec.name == 'faster_rubygems' && RUBY_VERSION[0..2] == '1.8'
     require "faster_rubygems/unoverride" # just in case
  end
}