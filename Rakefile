require 'cucumber'
require 'cucumber/rake/task'

# Run the profiles specified in the following tasks. We can use these profiles to run particular tests first or last.
# eg. because they are less important or still need some more work to finish. Or even to run the sam tests in different browsers!!
namespace "tests" do
  task "default_chrome" do
		sh "cucumber -p default_chrome"
  end
end

namespace "tests" do
  task "default_firefox" do
		sh "cucumber -p default_firefox"
  end
end

task "default" do
  %W[tests:default_chrome tests:default_firefox].each do |task_name|
    sh "rake #{task_name}" do
			#ignore any errors
			puts "TASK NAME: '#{task_name}' has finished running\n\n"
		end
  end
end

# Runs just the default profile
# Note: Passing parameter 't' into the block is just to configure the cucumber task (that we created)
Cucumber::Rake::Task.new() do |t|
  t.profile = 'default'
#  t.cucumber_opts = "--format progress"
end
task :default => :cucumber

