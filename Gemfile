source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# For import data
#gem 'activerecord-import'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'

# Database
gem 'pg'
gem 'pg_search'

# For serialize data
gem 'active_model_serializers'

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Json web token
gem 'jwt'

# For pagination
gem 'kaminari'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# For the Sentry error reporting API.
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'

# Background job
gem 'sidekiq'

# suppress unwanted logs
gem 'silencer'

# for versioning Rails based RESTful APIs
gem 'versionist'

# Cron job
gem 'clockwork'

# sorting and reordering objects
# gem 'acts_as_list'

# Send email by sendgrid
# gem 'sendgrid-ruby'

group :development, :test, :production do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'dotenv-rails'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Permission
gem 'cancancan'

# simple DSL for accessing HTTP and REST resources
# gem 'rest-client'
