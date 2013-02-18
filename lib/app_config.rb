require "app_config/version"
require "app_config/engine"
require "app_config/repo"

unless defined?(::Conf)
  c = AppConfig::Repo.new
  if File.exists?("#{Rails.root}/config/config.local.yml")
    c.use_file!("#{Rails.root}/config/config.local.yml")
  end
  c.use_file!("#{Rails.root}/config/config.yml")
  c.use_section!(Rails.env)
  ::Conf = c
end