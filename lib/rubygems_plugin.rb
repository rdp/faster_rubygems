Gem.post_install {
  require "faster_rubygems/create_cache_for_all"
}

Gem.post_uninstall {
  require "faster_rubygems/create_cache_for_all"
}

Gem.pre_uninstall { |gem_installer_instance, gem_spec|
  
  if gem_installer_instance.spec.name == 'faster_rubygems' && RUBY_VERSION[0..2] == '1.8'
    begin
       require "faster_rubygems/unoverride" # just in case
    rescue Errno::ENOENT
      puts 'warning: unable to unoverride faster_rubygems--might be expected if you had several versions installed'
    end  
  end
}