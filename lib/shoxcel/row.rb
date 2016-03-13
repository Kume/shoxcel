# -*- coding: utf-8 -*-

module Shoxcel
  class Row
    def initialize row
      @row = row
    end

    def []= index

    end

    def []
      Cell.new(row.get_cell(sel2) || row.create_cell(sel2))
    end
  end
end