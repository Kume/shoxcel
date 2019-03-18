require_relative 'area_template'
require_relative 'util'

module Shoxcel
  class SheetTemplate
    def self.create(definition)
      case definition['type']
      when 'map'
        return MapSheetTemplate.new(definition)
      when 'fixed', nil
        return FixedSheetTemplate.new(definition)
      else
        raise "invalid sheet template type #{definition['type']}"
      end
    end

    def self.apply(book, sheet_templates, data, global)
      sheet_templates.each do |sheet_template|
        sheet = book[sheet_template.name_from]
        raise "sheet #{sheet_template.name_from} not found" unless sheet

        sheet_template.apply(sheet, data, global)
      end
    end

    def initialize(definition)
      @name = definition['name']
      @areas = definition['areas'].map do |area|
        AreaTemplate.create(area)
      end
      @data = definition['data']
    end

    def name_from
      case @name
      when String
        return @name
      when Hash
        return @name['from']
      else
        raise "invalid book name #{@name}"
      end
    end
  end

  class MapSheetTemplate < SheetTemplate
    def initialize(definition)
      super
    end

    def name_to
      case @name
      when Hash
        return @name['to']
      else
        raise "invalid book name type #{@name.class} for MapSheetTemplate"
      end
    end

    def apply(sheet, data, global)
      data = @data ? data.dig(*@data.split('.')) : data['_d']
      Util.each_template_data(data, global) do |template_data|
        output_name = Mustache.render(name_to, template_data)
        mapped_sheet = sheet.clone
        AreaTemplate.apply(mapped_sheet, @areas, template_data, global)
        mapped_sheet.name = output_name
      end
      sheet.destroy
    end
  end

  class FixedSheetTemplate < SheetTemplate
    def initialize(definition)
      super
    end

    def apply(sheet, data, global)
      # TODO
    end
  end
end
