class AppConfig::Railtie < Rails::Railtie

  initializer 'app_config.initializer' do
    c = AppConfig::Repo.new
    c.use_file!("#{Rails.root}/config/config.local.yml")
    c.use_file!("#{Rails.root}/config/config.yml")
    c.use_section!(Rails.env)
    ::Conf = c
  end

end