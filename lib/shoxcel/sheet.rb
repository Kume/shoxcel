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

    def copy_row srcRowIndex, dstRowIndex
      source = @sheet.get_row srcRowIndex

      destination = @sheet.get_row dstRowIndex
      if destination
        @sheet.shift_rows dstRowIndex, @sheet.get_last_row_num, 1
      else
        destination = @sheet.create_row dstRowIndex
      end

      for i in 0...(source.get_last_cell_num)
        source_cell = source.get_cell(i)
        if source_cell
          cell = destination.create_cell(i)
          style = @sheet.get_workbook.create_cell_style
          style.clone_style_from source_cell.get_cell_style
          cell.set_cell_style style

          cell.set_cell_comment comment if (comment = source_cell.get_cell_comment)
          cell.set_hyperlink hyperlink if (hyperlink = source_cell.get_hyperlink)
          cell.set_cell_type source_cell.get_cell_type

          case cell.get_cell_type
            when ::Cell::CELL_TYPE_BLANK
              cell.set_cell_value source_cell.get_string_cell_value
            when Cell::CELL_TYPE_BOOLEAN
              cell.set_cell_value source_cell.get_boolean_cell_value
            when Cell::CELL_TYPE_ERROR
              cell.set_cell_error_value source_cell.get_error_cell_value
            when Cell::CELL_TYPE_FORMULA
              cell.set_cell_value source_cell.get_cell_formula
            when Cell::CELL_TYPE_NUMERIC
              cell.set_cell_value source_cell.get_numeric_cell_value
            when Cell::CELL_TYPE_STRING
              cell.set_cell_value source_cell.get_rich_string_cell_value
          end
        end
      end
    end
  end
end