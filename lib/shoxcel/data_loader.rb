require 'yaml'

module Shoxcel
  class DataLoader
    def self.load directory, data_settings
      data = {}
      data_settings.each do |key, setting|
        if setting['source']
          data[key] = YAML::load_file(File.join(directory, setting['source']))
        end
      end
      return data
    end
  end
end