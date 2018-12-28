source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# gem 'therubyracer', platforms: :ruby
# もし coffeescript などで v8 を利用しているなら mini_racer に変更すべき
# gem 'mini_racer', platforms: :ruby
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem 'rails-footnotes' # Rails 5.2 ではエラー続出
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'tzinfo-data'

# CSS
gem 'bootstrap-sass'
gem 'honoka-rails'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'font-awesome-rails'

# Bulk Insert
gem 'activerecord-import'

# ユーザ管理
gem 'devise'
gem 'omniauth-twitter'

# Ajax
gem 'jquery-turbolinks'

# ネスト構造のフォーム用
gem 'nested_form_fields'

# Javascript/Coffeescript 拡張用
gem 'gon'

# for PDF generation
gem 'prawn'
gem 'prawn-table'

# for zip file decompression
gem 'rubyzip'

# for here document
gem 'unindent'

# for sinble elimination bracket output
gem 'rubytree'

# for enum i18n
gem 'enum_help'

# for string to boolean
gem 'to_bool'

# 開発作業用ツール
group :tools do

  # ERD出力
  gem 'rails-erd'

  # マイグレーションファイルをinit_schemaに纏めるツール
  gem 'squasher', '>= 0.6.2'
end

# 運用向けツール
gem 'addressable'
