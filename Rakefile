require 'cucumber'
require 'cucumber/rake/task'

# Declare all tasks. We can then specify which tasks we want to run from the command line
# or from within TeamCity CI
namespace 'creatures' do
		Cucumber::Rake::Task.new(:ff_json) do |t|
			t.profile = 'default_firefox_json'
		end
		Cucumber::Rake::Task.new(:ff_junit) do |t|
			t.profile = 'default_firefox_junit'
		end
		Cucumber::Rake::Task.new(:ff_html) do |t|
			t.profile = 'default_firefox_html'
		end
end
	

