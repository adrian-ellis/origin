require 'cucumber'
require 'cucumber/rake/task'

# defined 2 separate tasks (using the proper cucumber task, not the generic rake task!) under 1 namespace.
# These can then be run in order by another here (eg. task features:ci). Then assign run that task to run
# as the 'default' task.
namespace :features do
  Cucumber::Rake::Task.new(:monogram_ff_html) do |t|
    t.profile = 'monogram_ff_html'
  end

  Cucumber::Rake::Task.new(:monogram_gg_html) do |t|
    t.profile = 'monogram_gg_html'
  end

  task :ci => ['monogram_gg_html', 'monogram_gg_html']
end

task :default => 'features:ci'