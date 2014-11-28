require 'cucumber'
require 'cucumber/rake/task'

# Create all rake tasks. We can invode them later.
task 'json' do
	sh 'cucumber -p default_firefox_json'
end

task 'junit' do
	sh 'cucumber -p default_firefox_json'
end

task 'html' do
	sh 'cucumber -p default_firefox_html'
end

# Declare 'calling' tasks. We can then specify which tasks we want to run from the command line
# or from within TeamCity CI
namespace 'features' do
	task 'run_json' do
		Rake::Task['json'].invoke
	end
end

namespace 'features' do
	task 'run_junit' do
		Rake::Task['junit'].invoke
	end
end

namespace 'features' do
	task 'run_html' do
		Rake::Task['html'].invoke
	end
end
