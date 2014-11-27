require 'cucumber'
require 'cucumber/rake/task'

# Create all rake tasks. We can invode them later.
Cucumber::Rake::Task.new(:ff_json) do |t|
	t.profile = 'default_firefox_json'
end

Cucumber::Rake::Task.new(:ff_junit) do |t|
	t.profile = 'default_firefox_junit'
end

Cucumber::Rake::Task.new(:ff_html) do |t|
	t.profile = 'default_firefox_html'
end

# Declare 'calling' tasks. We can then specify which tasks we want to run from the command line
# or from within TeamCity CI
namespace 'features' do
	task 'run_json' do
		Rake::Task[:ff_json].invoke
	end
end

namespace 'features' do
	task 'run_junit' do
		Rake::Task[:ff_junit].invoke
	end
end

namespace 'features' do
	task 'run_html' do
		Rake::Task[:ff_html].invoke
	end
end
