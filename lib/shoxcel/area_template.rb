require_relative 'string_template'

module Shoxcel
  class AreaTemplate
    def self.create(definition)
      case definition['type']
      when 'table'
        return TableAreaTemplate.new(definition)
      when 'replace'
        return ReplaceAreaTemplate.new(definition)
      else
        raise "invalid area template type #{definition['type']}"
      end
    end

    def self.apply(sheet, area_templates, data, global)
      template_target_pairs = area_templates.map do |area_template|
        [area_template, area_template.target(sheet)]
      end
      template_target_pairs.each do |pair|
        pair[0].apply(sheet, pair[1], data, global)
      end
    end

    def initialize(definition)
      @name = definition['name']
      @data = definition['data']
    end
  end

  class ReplaceAreaTemplate < AreaTemplate
    def initialize(definition)
      super
      @map = definition['replace_map']
    end

    def target(sheet)
      map_cells = {}
      @map.each do |k, v|
        cell = sheet.find_cell_by_text(k)
        raise "cell #{k} not found." unless cell
        map_cells[k] = cell
      end
      map_cells
    end

    def apply(sheet, target, data, global)
      data = Util.make_template_data(data['_d'], global, path: @data) if @data
      target.each do |key, cell|
        cell.value = Mustache.render(@map[key], data)
      end
    end
  end

  class TableAreaTemplate < AreaTemplate
    def initialize(definition)
      super
      @area = definition['area']
      @top_offset = definition['top_offset'] || 0
      @bottom_offset = definition['bottom_offset'] || 0
      @header_height = definition['header_height'] || 1
      @column_map = definition['column_map']
    end

    def target(sheet)
      top_left = sheet.find_cell_by_text_or_fail(@area['top_left'])
      bottom_right = sheet.find_cell_by_text_or_fail(@area['bottom_right'])
      header_row_index = top_left.row_index + @top_offset
      header_row = sheet[header_row_index]
      column_cells = {}
      @column_map.each do |k, v|
        cell = header_row.find_cell_by_text_or_fail(k)
        column_cells[k] = cell
      end
      default_row = sheet[header_row_index + @header_height]

      {
          top_left: top_left,
          bottom_right: bottom_right,
          column_cells: column_cells,
          default_row: default_row,
      }
    end

    def apply(sheet, target, data, global)
      data = @data ? data.dig(*@data.split('.')) : data['_d']
      column_indexes = {}
      target[:column_cells].each do |key, value|
        column_indexes[key] = value.column_index
      end

      top_index = target[:top_left].row_index
      template_row_count = target[:bottom_right].row_index - top_index - @top_offset - @bottom_offset - @header_height + 1
      Util.each_template_data(data, global) do |template_data|
        insert_index = target[:bottom_right].row_index - @bottom_offset + 1
        inserted_row = sheet.insert_row(insert_index, target[:default_row])
        column_indexes.each do |column_key, column_index|
          inserted_row[column_index].value = Mustache.render(@column_map[column_key], template_data)
        end
      end

      (0...@top_offset).each do
        sheet.remove_row(top_index)
      end
      (0...template_row_count).each do
        sheet.remove_row(top_index + @header_height)
      end
      bottom_index = target[:bottom_right].row_index - @bottom_offset + 1
      (0...@bottom_offset).each do
        sheet.remove_row(bottom_index)
      end
    end
  end
end
