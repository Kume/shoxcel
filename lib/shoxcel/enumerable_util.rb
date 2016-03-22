module Shoxcel
  class EnumerableUtil
    def self.each enumerable, &block
      case enumerable
        when Array
          enumerable.each_with_index { |v, i| yield i, v }
        when Hash
          enumerable.each &block
      end
    end

    def self.map enumerable, &block
      case enumerable
        when Array
          enumerable.map.with_index { |v, i| yield i, v }
        when Hash
          enumerable.map &block
      end
    end
  end
end