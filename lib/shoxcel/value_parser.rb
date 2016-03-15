
module Shoxcel
  class ValueParser
    def initialize data, context = nil
      @data = data
      @context = context
    end

    def parse expression
      tokens = expression.split('.')
      return nil if tokens.size == 0

      case tokens[0]
        when 'data'
          return get_path_value(@data, tokens[1..(-1)])

        when 'this'
          raise 'can not use "key" in the context.' if @context == nil || @context.size == 0
          return get_path_value(@data, @context + tokens[1..(-1)])

        when 'key'
          raise 'can not use "key" in the context.' if @context == nil || @context.size == 0
          return @context.last

        when 'string'
          if tokens.size > 1
            return tokens[1]
          else
            return ''
          end
      end
    end

    def get_path_value data, tokens
      raise 'invalid tokens' unless Array === tokens
      return data if tokens.size == 0
      case data
        when Array
          value = data[tokens[0].to_i]
        when Hash
          value =  data[tokens[0].to_s]
        else
          return nil
      end

      if tokens.size > 1
        return get_path_value value, tokens[1..(-1)]
      else
        return value
      end
    end
  end
end