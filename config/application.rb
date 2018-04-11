require_relative 'boot'

require 'rails/all'
require 'csv'
require 'zip'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RoboconDb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.autoload_paths << Rails.root.join("app/models/game_details")

    config.time_zone = 'Tokyo'

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true, # モデル作成時にfixtureの作成を有効化
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                      controller_specs: true, # コントローラー作成時
                       request_specs: false
      # fixture の代わりに factory_bot を利用する
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
