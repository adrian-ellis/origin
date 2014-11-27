require 'cucumber'
require 'cucumber/rake/task'

# Runs just the default profile
# Note: Passing parameter 't' into the block is just to configure the cucumber task (that we created)
all_profiles = ['default_firefox_html','default_firefox_json','default_firefox_junit']
all_profiles.each do |p|
	Cucumber::Rake::Task.new() do |t|
		t.profile = p
	end
	task :default => :cucumber
end

