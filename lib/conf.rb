require 'yaml'
require 'ostruct'

class Conf
  def self.init_config(config_file)
    config_hash = {}
    if File.exist?(config_file)
      config_hash = YAML.load_file(config_file)
    end
    config = OpenStruct.new(config_hash)

    defaults = {
      :up           => 'k', 
      :down         => 'j', 
      :left         => 'h', 
      :right        => 'l', 
      :quit         => 'q', 
      :restart      => 'r', 
      :help         => '?', 
      :choose_stage => 's', 
    }
    config.keys ||= {}
    config.keys.reverse_merge!(defaults)
    config.keys.each do |key,value|
      config.keys[key] = value.to_s[0]
    end
    config
  end
end
