Gem.post_install {
  # accomodate for when they install more than one at a time...
  # a straight require won't cut it...
  success = require "faster_rubygems/create_cache_for_all"
  if !success
    Gem.create_cache_for_all!  
  end
}

Gem.post_uninstall {
  success = require "faster_rubygems/create_cache_for_all"
  if !success
    Gem.create_cache_for_all!  
  end
}

Gem.pre_uninstall { |gem_installer_instance|
  
  if gem_installer_instance.spec.name == 'faster_rubygems' && RUBY_VERSION[0..2] == '1.8'
    begin
       require "faster_rubygems/unoverride" # just in case
    rescue Errno::ENOENT
      puts 'warning: unable to unoverride faster_rubygems--might be expected if you had several versions installed'
    end  
  end
}