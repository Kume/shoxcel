# -*- coding: utf-8 -*-

require 'java'

require_relative 'lib/shoxcel'


require 'yaml'

data = File.read('./samples/db/direction.yaml')
direction = YAML::load(data)


class ExcelBook
  def initialize path
    @path = path
    @input_file = FileInputStream.new(path)
    @book = WorkbookFactory::create(@input_file)
  end

  def self.open path, &block
    book = ExcelBook.new(path)
    return book unless block_given?
    yield book
  ensure
    book.close
  end

  def [] sheetSelector
    case sheetSelector
      when String
        sheet = @book.getSheet(sheetSelector)
      when Integer
        sheet  @book.getSheetAt(sheetSelector)
      else
        raise 'invalid sheet selector'
    end

    sheet.set_force_formula_recalculation true
    return ExcelSheet.new sheet
  end

  def saveAs filePath
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

class ExcelSheet
end

ExcelBook.open './samples/db/template.xlsx' do |book|
  puts 'test'
  book['表紙'][0, 1] = 'test'
  table_sheet = book['テーブル']
  table_sheet.copy_row(7, 8)
  table_sheet.copy_row(7, 8)
  table_sheet.copy_row(7, 8)
  book.saveAs './output.xlsx'
end

# @book_file = FileInputStream.new('./samples/db/template.xlsx')
# @book = WorkbookFactory::create(@book_file)
#
#
# @output = FileOutputStream.new('./output.xlsx')
# @book.write(@output)
#
# @book_file.close
# @book.close