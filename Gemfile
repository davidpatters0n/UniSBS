source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'rake', '0.9.2.2'


gem 'devise'
gem 'faraday'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem 'mysql'
#gem "mysql2", "~> 0.3.11"

gem 'mysql2', :group => [:development, :test]
group :production do
  gem 'thin'
  gem 'pg'
end


group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'execjs'
#gem 'therubyracer'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'



