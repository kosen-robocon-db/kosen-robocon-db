ruby "2.2.6"

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-footnotes'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end

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

# CSV Download
# gem 'to_csv-rails'

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

# 開発作業用ツール
group :tools do
  # gem 'rails-erd', group: [:development, :test]
  # ERD出力
  gem 'rails-erd'

  # マイグレーションファイルをinit_schemaに纏めるツール
  gem 'squasher', '>= 0.6.0'
end
