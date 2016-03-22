# -*- coding: utf-8 -*-

module Shoxcel
  class Cell
    attr_reader :cell

    def initialize cell
      @cell = cell
    end

    def value
      case @cell.get_cell_type
        when ::Cell::CELL_TYPE_BLANK
          return @cell.get_string_cell_value
        when ::Cell::CELL_TYPE_BOOLEAN
          return @cell.get_boolean_cell_value
        when ::Cell::CELL_TYPE_ERROR
          return @cell.get_error_cell_value
        when ::Cell::CELL_TYPE_FORMULA
          return @cell.get_cell_formula
        when ::Cell::CELL_TYPE_NUMERIC
          return @cell.get_numeric_cell_value
        when ::Cell::CELL_TYPE_STRING
          return @cell.get_rich_string_cell_value
      end
    end

    def value= v
      @cell.set_cell_value v
    end

    def copy_all_from source
      style = @cell.get_sheet.get_workbook.create_cell_style
      style.clone_style_from source.cell.get_cell_style
      @cell.set_cell_style style

      @cell.set_cell_comment comment if (comment = source.cell.get_cell_comment)
      @cell.set_hyperlink hyperlink if (hyperlink = source.cell.get_hyperlink)
      @cell.set_cell_type source.cell.get_cell_type
      return self
    end
  end
end