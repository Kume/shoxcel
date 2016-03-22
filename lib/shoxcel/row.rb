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

    def find_by_text text
      for i in 0...size
        if self[i].value.to_s == text
          return i
        end
      end
    end
  end
end