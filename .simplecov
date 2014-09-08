SimpleCov.start do
  add_group "Generators", "lib/generators"
  add_group "Lib", "lib/yodeler"
  add_filter "app/"
  add_filter "config/"  
  add_filter "spec/"
end