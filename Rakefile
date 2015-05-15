# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Ipams::Application.load_tasks

# Add tests for rake tasks to the rails test list
# See http://stackoverflow.com/questions/18894060/rails-and-minitest-add-additional-folder
namespace :test do
  desc "Test rake tasks"
  Rake::TestTask.new(:tasks) do |t|
    t.libs << "test"
    t.pattern = 'test/tasks/*_test.rb'
    t.verbose = true
  end
end

Rake::Task[:test].enhance { Rake::Task["test:tasks"].invoke }
