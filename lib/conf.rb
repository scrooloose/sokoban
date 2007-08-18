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
    config.keys[:up] ||= 'k'
    config.keys[:down] ||= 'j'
    config.keys[:left] ||= 'h'
    config.keys[:right] ||= 'l'
    config.keys[:quit] ||= 'q'
    config.keys[:restart] ||= 'r'

    config
  end
end
