puts 'in mkrf'
load File.dirname(__FILE__) + "/install.rb" # install it for them

  f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
  f.write("task :default\n")
  f.close