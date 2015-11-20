# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if %w(development test).include?(Rails.env)
  desc "start the credit card processor in the console"
  task :start do
    sh 'bin/run'
  end
end
