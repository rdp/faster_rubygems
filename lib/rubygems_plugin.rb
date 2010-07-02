Gem.post_install {
  # accomodate for when they install more than one at a time...
  # a straight require won't cut it...
  print 'because of new gem installation '
  load "faster_rubygems/create_cache_for_all.rb"
}

Gem.post_uninstall {
  print 'because of gem uninstallation '
  load "faster_rubygems/create_cache_for_all.rb"
}

Gem.pre_uninstall { |gem_installer_instance|
  if gem_installer_instance.spec.name == 'faster_rubygems' && RUBY_VERSION[0..2] == '1.8'
    puts 'removing faster_rubygems as the default for require rubygems...'
    begin
       # don't need load here since...doing it once is enough
       require "faster_rubygems/unoverride" # just in case
    rescue Errno::ENOENT
      puts 'warning: unable to unoverride faster_rubygems--might be expected if you had several versions installed'
    end  
  end
}