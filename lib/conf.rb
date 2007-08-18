require 'yaml'
require 'ostruct'

class Conf
  def self.init_config(config_file)
    config_hash = {}
    if File.exist?(config_file)
      config_hash = YAML.load_file(config_file)
    end
    config = OpenStruct.new(config_hash)

    config.keys ||= {}
    config.keys[:up] ||= '8'
    config.keys[:down] ||= '2'
    config.keys[:left] ||= '4'
    config.keys[:right] ||= '6'
    config.keys[:quit] ||= 'q'

    config
  end
end
