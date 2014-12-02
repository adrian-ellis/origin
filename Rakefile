require 'cucumber'
require 'cucumber/rake/task'

# Run the profiles specified in the following tasks. We can use these profiles to run particular tests first or last.
# eg. because they are less important or still need some more work to finish. Or even to run the same tests in different browsers!!
namespace "features" do
  task "default_ff_html" do
		# Run cucumber from within a shell. By doing it this way the task running "default_firefox..." can then handle what happens when an error occurs
		sh "cucumber -p default_firefox_html" do
			# Ignore any errors generated from the task. This is the reason why we run from within a shell.
		end
  end
end

namespace "features" do
  task "default_ff_json" do
		# Run cucumber from within a shell. By doing it this way the task running "default_firefox..." can then handle what happens when an error occurs
		sh "cucumber -p default_firefox_json" do
    # Ignore any errors generated from the task. This is the reason why we run from within a shell.
    end
  end
end

namespace "features" do
  task "monogram_ff_html" do
		# Run cucumber from within a shell. By doing it this way the task running "default_firefox..." can then handle what happens when an error occurs
		sh "cucumber -p monogram_ff_html" do
			# Ignore any errors generated from the task. This is the reason why we run from within a shell.
		end
  end
end

namespace "features" do
  task "monogram_gg_html" do
    # Run cucumber from within a shell. By doing it this way the task running "default_google..." can then handle what happens when an error occurs
    sh "cucumber -p monogram_gg_html" do
      # Ignore any errors generated from the task. This is the reason why we run from within a shell.
    end
  end
end

# the default task here runs any other tasks already defined.
task "default" do
  %W[features:monogram_ff_html features:monogram_gg_html features:default_ff_html features:default_ff_json].each do |task_name|
    sh "rake #{task_name}" do
			# Ignore any errors generated from the task. This is the reason why we run from within a shell.
		end
  end
end

