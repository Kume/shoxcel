# -*- coding: utf-8 -*-

module Shoxcel
  class Sheet
    def initialize sheet
      @sheet = sheet
    end

    def []= sel1, sel2, value
      row = @sheet.get_row(sel1) || @sheet.create_row(sel1)
      cell = row.get_cell(sel2) || row.create_cell(sel2)
      cell.set_cell_value(value)
    end

    def [] index
      Row.new(@sheet.get_row(index) || @sheet.create_row(index))
    end

    def clone
      workbook = @sheet.get_workbook
      Sheet.new workbook.clone_sheet(workbook.get_sheet_index(@sheet))
    end

    def insert_row index, source_row
      if index < @sheet.get_last_row_num
        @sheet.shift_rows index, @sheet.get_last_row_num, 1
      end

      destination = self[index]

      for i in 0...(source_row.size)
        source_cell = source_row[i]
        destination[i].copy_all_from(source_row[i])
      end

      # TODO セルの結合

      return destination
    end
  end
end