module AppConfig
  class Engine < Rails::Engine

    config.railties_order = [AppConfig::Engine, :main_app, :all]

    config.to_prepare do

    end

  end
end