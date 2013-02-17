require "app_config/version"
require "app_config/system_params"

class AppConfig

  def initialize(file = nil)
    @sections = {}
    @params = {}
    use_file!(file) if file
  end

  def use_file!(file)
    begin
      hash = YAML::load(ERB.new(IO.read(file)).result)
      @sections = hash.merge(@sections) { |_, old_val, new_val| (old_val || new_val).merge new_val }
      @params.merge!(@sections['common'])
    rescue; end
  end

  def use_section!(section)
    @params.merge!(@sections[section.to_s]) if @sections.key?(section.to_s)
  end

  def get(name)
    value = @params
    name.split('.').each do |key|
      value = value[key]
    end

    if value.is_a?(Hash) && value.key?("default")
      if value.key?(APP_NAME_SHORT)
        return value[APP_NAME_SHORT]
      else
        return value["default"]
      end
    else
      return value
    end
  end

  def method_missing(param)
    param = param.to_s
    if @params.key?(param)
      @params[param]
    else
      Conf::SystemParams[param]
    end
  end

end

c = AppConfig.new
c.use_file!("#{Rails.root}/config/config.local.yml")
c.use_file!("#{Rails.root}/config/config.yml")
c.use_section!(Rails.env)
::Conf = c