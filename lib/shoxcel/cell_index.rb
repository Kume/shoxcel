
module Shoxcel
  class CellIndex
    attr_reader :row, :column

    def initialize index
      case index
        when Array
          @column = index[0]
          @row = index[1]
        when String
          raise "invalid index #{index}" unless index.downcase =~ /^([a-z]+)([0-9]+)$/
          str = ""
          for i in 0...($1.size)
            str += ($1[i].ord - 11).chr
          end
          @column = str.to_i 26
          @row = $2.to_i - 1
      end
    end
  end
end
