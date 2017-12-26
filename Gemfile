#source 'https://rubygems.org'
# If https above cannot work, try this
source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Use Capistrano for deployment
# http://goo.gl/mdE7gl
#gem 'capistrano', group: :development
#gem 'capistrano-passenger'

# rails specific capistrano funcitons
#gem 'capistrano-rails', '~> 1.1.0'

# integrate bundler with capistrano
#gem 'capistrano-bundler'

# if you are using RBENV
#gem 'capistrano-rbenv', "~> 2.0", require: false 

# Bootstrap 3 support
# http://www.gotealeaf.com/blog/integrating-rails-and-bootstrap-part-1/
gem 'bootstrap-sass'

# http://fortawesome.github.io/Font-Awesome/get-started/
gem 'font-awesome-sass'

gem 'autoprefixer-rails', '~> 4.0.2.2'
# https://github.com/sstephenson/execjs#readme for more supported runtimes
# To fix TypeError: Cannot read property 'process' of undefined
# caused by autoprefixer-rails gem 5.0 
#gem 'therubyracer', platform: :ruby

# In-place editing support
# https://github.com/GuanglinDu/bootstrap-x-editable-rails-demo 
gem 'bootstrap-x-editable-rails'

# Rails-bootstrap-forms is a Rails form builder that makes it super easy to
# create beautiful-looking forms with Twitter Bootstrap 3+.
# https://github.com/bootstrap-ruby/rails-bootstrap-forms
gem 'bootstrap_form'

# Authenticates with devise
# https://github.com/plataformatec/devise
gem 'devise'

# Authorizes with pundit, added on Jan. 11, 2014
# https://github.com/elabs/pundit
gem 'pundit'

# Uses the lightweight httpd server thin instead of the default Webricks
gem 'thin'

# Paginates with will_paginate-bootstrap
# https://github.com/bootstrap-ruby/will_paginate-bootstrap
gem 'will_paginate-bootstrap'

# Full-text search support with Sunspot
# https://github.com/sunspot/sunspot
# https://github.com/outoftime/sunspot/wiki
gem 'sunspot_rails'
# Optional pre-packaged Solr distribution for use in development
gem 'sunspot_solr'
gem 'progress_bar'

# Enables https
gem 'rack-ssl', '~> 1.4.1'

# Exports to MS Excel files
gem 'axlsx', '~> 2.0'
gem "axlsx_rails"

# https://github.com/rspec/rspec-rails
# https://github.com/thoughtbot/factory_girl_rails
group :development, :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails'
end

# https://github.com/michaeldv/awesome_print
# https://github.com/stympy/faker
group :development do
  gem 'awesome_print'
  gem 'faker'
  gem 'byebug'
end

# Makes testing more friendly
group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace', '0.1.3'
  gem 'guard-minitest', '2.3.1'
  gem 'database_cleaner'
  gem 'capybara'
end

# bundle exec rake doc:rails generates the API under doc/api.
group :doc do
  gem 'sdoc', require: false
end
