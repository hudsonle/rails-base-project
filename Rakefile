# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :db do
  task :before do
    next if Rails.env.test?
    db_host = ENV.fetch("RAILS_DB_HOST") { "localhost" }
    db_name = ENV.fetch("RAILS_DB_NAME") { "fxce-notifier-dev" }

    if db_name.present?
      puts "WARNING!! You are using: #{db_host} - #{db_name}"
      puts "Are you sure? (y/n)"
      choice = STDIN.gets.strip

      if choice != 'y'
        puts 'No action taken'
        exit
      end
    end
  end

  Rake::Task['db:setup'].enhance(['before'])
  Rake::Task['db:create'].enhance(['before'])
  Rake::Task['db:migrate'].enhance(['before'])
  Rake::Task['db:migrate:reset'].enhance(['before'])
  Rake::Task['db:migrate:up'].enhance(['before'])
  Rake::Task['db:migrate:down'].enhance(['before'])
  Rake::Task['db:migrate:redo'].enhance(['before'])
  Rake::Task['db:structure:load'].enhance(['before'])
  Rake::Task['db:schema:load'].enhance(['before'])
  Rake::Task['db:rollback'].enhance(['before'])
  Rake::Task['db:seed'].enhance(['before'])
  Rake::Task['db:drop'].enhance(['before'])
  Rake::Task['db:drop:all'].enhance(['before'])
  Rake::Task['db:reset'].enhance(['before'])
end
