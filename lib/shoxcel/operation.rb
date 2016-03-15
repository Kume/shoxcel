module Shoxcel
  class Operation
    def self.create settings, sheet = nil, context = nil
      operations = []
      settings.each do |setting|
        operation_name = setting["operation"]
        case operation_name
          when "map_sheet"
            raise "invalid operation #{operation_name} in sheet context" if sheet
            operations << MapSheetOperation.new(setting, context)
          when "fill"
            setting["sheet"] = sheet if sheet
            operations << FillOperation.new(setting, context)
          else
            raise "invalid operation name #{operation_name}"
        end
      end
      return operations
    end
  end

  class FillOperation < Operation
    def initialize params, context
      @params = params
      @cell = params["cell"]
      @value = params["value"]
      @map = params["map"]
      @sheet = params["sheet"]
      @context = context
    end

    def exec book, data
      if @cell && @value
        cell_index = CellIndex.new @cell
        parser = ValueParser.new data, @context
        book[@sheet][cell_index.row][cell_index.column].value = parser.parse(@value)
      end
    end
  end

  class MapSheetOperation < Operation
    def initialize params, context
      @params = params
      @context = context
    end

    def exec book, data

    end

    # 仮置きメソッド
    def map book
      @operations = (params["operations"] || []).map do |operation|
        Operation.create operation, book
      end
    end
  end
end