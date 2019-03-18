# -*- coding: utf-8 -*-

module Shoxcel
  class Row
    def initialize row
      @row = row
    end

    def size
      @row.get_last_cell_num
    end

    def [] index
      Cell.new(@row.get_cell(index) || @row.create_cell(index))
    end

    def destroy
      @row.get_sheet.remove_row @row
    end

    def find_index_by_text text
      for i in 0...size
        if self[i].value.to_s == text
          return i
        end
      end
    end

    def find_cell_by_text(text)
      find_cell do |cell|
        cell.value.to_s === text
      end
    end

    def find_cell_by_text_or_fail(text)
      find_cell_by_text(text) || (raise "cell #{text} not found.")
    end

    def find_cell
      for i in 0...size
        return self[i] if yield(self[i], i)
      end
      return
    end
  end
end