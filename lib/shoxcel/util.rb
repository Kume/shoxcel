require 'mustache'

module Shoxcel
  module Util
    def self.make_template_data(data, global, key: nil, path: nil, context: {})
      if Hash === data
        template_data = data.clone
      else
        template_data = {}
      end
      template_data['_d'] = data
      template_data['_g'] = global
      template_data['_c'] = context
      template_data['_key'] = key if key
      return template_data unless path
      split_key = path.split('.')
      make_template_data(data.dig(split_key), global, key: split_key.last)
    end

    def self.each_template_data(data, global, context: {}, context_name: nil)
      case data
      when Array
        data.each do |value|
          current_context = context.clone
          if context_name
            current_context[context_name] = value
          end
          template_data = make_template_data(value, global, context: current_context)
          yield template_data, value
        end
      when Hash
        data.each do |key, value|
          current_context = context.clone
          if context_name
            current_context[context_name] = value
          end
          template_data = make_template_data(value, global, key: key, context: current_context)
          yield template_data, value
        end
      when nil
        # nilは空配列と同じ扱い
      else
        raise "Invalid data type #{data.class} for each_template_data"
      end
    end
  end
end