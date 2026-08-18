source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.1.3', '>= 8.1.3.1'

# Use Puma as the app server
gem 'puma', '>= 6.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Use upload file to avatar user. Read more: https://github.com/carrierwaveuploader/carrierwave
gem 'carrierwave', '~> 2.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'blueprinter', '~> 1.3'

gem 'tzinfo-data', platforms: [:windows, :jruby]

gem 'sqlite3', '>= 2.1'

group :development, :test do
  gem 'pry-rails', '~> 0.3.9'
  gem 'database_cleaner'
  gem 'ffaker', '2.13.0'
  gem 'factory_bot_rails', '5.1.1'
  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 8.0'
  gem 'rubocop', '~> 1.88', require: false
  gem 'rubocop-rails', '~> 2.36', require: false
  gem 'rubocop-rspec', '~> 3.10', require: false
  gem 'shoulda-matchers', '4.1.2'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
