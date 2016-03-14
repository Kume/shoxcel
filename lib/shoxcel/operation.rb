module Shoxcel
  class Operation
    def self.create settings, sheet = nil
      operations = []
      settings.each do |setting|
        operation_name = setting["operation"]
        case operation_name
          when "map_sheet"
            raise "invalid operation #{operation_name} in sheet context" if sheet
            operations << MapSheetOperation.new(setting)
          when "fill"
            setting["sheet"] = sheet if sheet
            operations << FillOperation.new(setting)
          else
            raise "invalid operation name #{operation_name}"
        end
      end
      return operations
    end
  end

  class FillOperation < Operation
    def initialize params
      @params = params
      @cell = params["cell"]
      @value = params["value"]
      @map = params["map"]
      @sheet = params["sheet"]
    end

    def exec book
      if @cell && @value
        cell_index = CellIndex.new @cell
        book[@sheet][cell_index.row][cell_index.column].value = @value
      end
    end
  end

  class MapSheetOperation < Operation
    def initialize params
      @params = params
    end

    def exec book

    end

    # 仮置きメソッド
    def map book
      @operations = (params["operations"] || []).map do |operation|
        Operation.create operation, book
      end
    end
  end
end