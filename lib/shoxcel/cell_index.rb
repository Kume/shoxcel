
module Shoxcel
  class CellIndex
    attr_reader :row, :column

    def initialize index
      case index
        when Array
          @column = index[0]
          @row = index[1]
        when String
          raise "invalid index #{index}" unless index.upcase =~ /^([A-Z]+)([0-9]+)$/
          column = $1
          @row = $2.to_i - 1
          str = ""
          for i in 0...(column.size)
            char_value = column[i] =~ /[A-J]/ ? (column[i].ord - 17) : (column[i].ord - 10)
            str += char_value.chr
          end
          @column = str.to_i 26
      end
    end
  end
end
