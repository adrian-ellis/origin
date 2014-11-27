require 'cucumber'
require 'cucumber/rake/task'

# Runs just the default profile
# Note: Passing parameter 't' into the block is just to configure the cucumber task (that we created)
#all_profiles = ['default_firefox_html','default_firefox_json','default_firefox_junit']
#all_profiles.each do |p|
#	Cucumber::Rake::Task.new() do |t|
#		t.profile = p
#	end
#	task :default => :cucumber
#end

Cucumber::Rake::Task.new(:firefox_json_task) do |t|
		t.profile = 'default_firefox_json'
end
#task :firefox_json_task => :cucumber

Cucumber::Rake::Task.new(:last_task) do |t|
		t.profile = 'default_chrome'
end
#task :last_task => :cucumber
	

