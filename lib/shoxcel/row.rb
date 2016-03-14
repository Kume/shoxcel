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
  end
end