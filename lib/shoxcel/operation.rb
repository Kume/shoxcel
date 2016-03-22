module Shoxcel
  class Operation
    def self.create settings, data, sheet = nil, context = nil
      operations = []
      settings.each do |setting|
        operation_name = setting["operation"]
        setting["sheet"] = sheet if sheet
        case operation_name
          when "map_sheet"
            raise "invalid operation #{operation_name} in sheet context" if sheet
            operations << MapSheetOperation.new(setting, data, context)
          when "fill"
            operations << FillOperation.new(setting, data, context)
          when "map_rows"
            operations << MapRowsOperation.new(setting, data, context)
          else
            raise "invalid operation name #{operation_name}"
        end
      end
      return operations
    end
  end

  class FillOperation < Operation
    def initialize params, data, context
      @params = params
      @map = params["map"]
      @sheet = params["sheet"]
      context = context

      @values = {}
      if params["cell"] && params["value"]
        cell_index = CellIndex.new params["cell"]
        parser = ValueParser.new data, context
        @values[cell_index] = parser.parse(params["value"])
      elsif params["values"]
        params["values"].each do |k, v|
          cell_index = CellIndex.new k
          parser = ValueParser.new data, context
          @values[cell_index] = parser.parse(v)
        end
      end
    end

    def exec book
      @values.each do |cell_index, value|
        book[@sheet][cell_index.row][cell_index.column].value = value
      end
    end
  end

  class MapSheetOperation < Operation
    def initialize params, data, context
      @params = params
      value = params["value"]
      @template_sheet = params['template_sheet']
      @sheet_name = params['sheet_name']
      parser = ValueParser.new data, context
      value_context = parser.get_context value
      value = parser.parse value
      @sheet_operations = []
      @sheet_names = []

      case value
        when Array
          value.each_with_index do |v, k|
            create_sheet_operation data, k, v, value_context
          end
        when Hash
          value.each do |k, v|
            create_sheet_operation data, k, v, value_context
          end
        else
          raise ''
      end
    end

    def exec book
      template_sheet = book[@template_sheet]
      @sheet_names.each_with_index do |sheet_name, i|
        sheet = template_sheet.clone
        sheet.name = sheet_name
        @sheet_operations[i].each do |operation|
          operation.exec book
        end
      end
      template_sheet.destroy
    end

    private
    def create_sheet_operation data, key, value, value_context
      context = value_context + [key]
      sheet_name = ValueParser.new(data, context).parse(@sheet_name)
      @sheet_names << sheet_name
      operations = (@params['operations'] || [])
      @sheet_operations << Operation.create(operations, data, sheet_name, context)
    end
  end

  class MapRowsOperation < Operation
    def initialize params, data, context
      @params = params
      @column_value_map = {}

      parser = ValueParser.new(data, context)
      rows = parser.parse params['value']
      rows_context = parser.get_context params['value']

      @row_values = EnumerableUtil.map rows do |i, row|
        values = EnumerableUtil.map params['map'] do |key, map|
          [map['template'], ValueParser.new(data, rows_context + [i]).parse(map['data'])]
        end
        Hash[*(values.flatten)]
      end

      EnumerableUtil.each params['map'] do |key, map|
        @column_value_map[map['template']] = EnumerableUtil.map rows do |i, row|
          ValueParser.new(data, rows_context + [i]).parse map['data']
        end
      end

      @header_row = params['header_row']
      @body_row = params['body_row']
      @sheet = params["sheet"]
    end

    def exec book
      sheet = book[@sheet]
      header = sheet[@header_row.to_i - 1]

      if @body_row
        body = sheet[@body_row.to_i - 1]
        unless @row_values.empty?
          header_map = {}
          @row_values.first.keys.each do |key|
            header_map[key] = header.find_by_text(key)
          end

          @row_values.reverse.each do |row_data|
            row = sheet.insert_row @header_row.to_i, body
            row_data.each do |key, value|
              row[header_map[key]].value = value if value
            end
          end
        end
        body.destroy
      end

      @column_value_map.each do |key, map|
        row_index = header.find_by_text(key)
        puts "key = #{key}, row_index = #{row_index}"
      end

      @row_values.each do |row|

      end
    end
  end
end