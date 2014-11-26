require 'cucumber'
require 'cucumber/rake/task'

# Runs just the default profile
# Note: Passing parameter 't' into the block is just to configure the cucumber task (that we created)
Cucumber::Rake::Task.new() do |t|
  t.profile = 'default_firefox'
#  t.cucumber_opts = "--format progress"
end
task :default => :cucumber

