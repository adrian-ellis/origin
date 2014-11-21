require 'cucumber'
require 'cucumber/rake/task'

# Runs the list of profiles specified in 'profiles' array. We can use these profiles to run these particular tests
# last because they are less important or still need some more work to finish. Or even to run different browsers!!
profiles = ['default_chrome', 'default_firefox']
profiles.each do |my_profile|
  Cucumber::Rake::Task.new() { |t| t.profile = my_profile }
  task my_profile => :cucumber
end

# Runs just the default profile
Cucumber::Rake::Task.new() do |t|
  #t.profile = 'default'
  t.profile = 'yo_optional'
  t.cucumber_opts = "--format progress"
end
task :default => :cucumber
