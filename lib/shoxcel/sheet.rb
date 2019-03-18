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

    def size
      @sheet.get_last_row_num
    end

    def clone
      workbook = @sheet.get_workbook
      Sheet.new workbook.clone_sheet(workbook.get_sheet_index(@sheet))
    end

    def destroy
      workbook = @sheet.get_workbook
      Sheet.new workbook.remove_sheet_at(workbook.get_sheet_index(@sheet))
    end

    def name
      @sheet.get_sheet_name
    end

    def name= n
      workbook = @sheet.get_workbook
      workbook.set_sheet_name workbook.get_sheet_index(@sheet), n
    end

    def insert_row index, source_row
      if index < size
        @sheet.shift_rows index, size, 1
      end

      destination = self[index]

      for i in 0...(source_row.size)
        destination[i].copy_all_from(source_row[i])
      end

      # TODO セルの結合

      return destination
    end

    def remove_row index, count = 1
      if index < size
        @sheet.shift_rows index + count, size, -count
      end
    end

    def each_rows
      for row_index in 0...size
        yield self[row_index]
      end
    end

    def find_row
      for row_index in 0...size
        return self[row_index] if yield(self[row_index], row_index)
      end
    end

    def find_cell_by_text(text)
      each_rows do |row|
        found = row.find_cell_by_text(text)
        return found if found
      end
      nil
    end

    def find_cell_by_text_or_fail(text)
      find_cell_by_text(text) || (raise "cell #{text} not found.")
    end
  end
end