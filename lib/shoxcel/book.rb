# -*- coding: utf-8 -*-

module Shoxcel
  class Book
    def initialize path
      @path = path
      @input_file = FileInputStream.new(path)
      @book = WorkbookFactory::create(@input_file)
    end

    def self.open path, &block
      book = Book.new(path)
      return book unless block_given?
      yield book
    ensure
      book.close
    end

    def [] sheet_selector
      case sheet_selector
        when String
          sheet = @book.getSheet(sheet_selector)
        when Integer
          sheet  @book.getSheetAt(sheet_selector)
        else
          raise "invalid sheet selector #{sheet_selector}"
      end

      sheet.set_force_formula_recalculation true
      return Sheet.new sheet
    end

    def save_as filePath
      @stream = FileOutputStream.new(filePath)
      @book.write(@stream)
      puts "save success"
    ensure
      @stream.close
    end

    def close
      @input_file.close
    end
  end
end