# -*- coding: utf-8 -*-

require 'java'

require_relative 'lib/shoxcel'


require 'yaml'

data = File.read('./samples/db/direction.yaml')
direction = YAML::load(data)


Shoxcel::Book.open './samples/db/template.xlsx' do |book|
  book['表紙'][0][1].value = 'test'
  table_sheet = book['テーブル']
  table_sheet.insert_row 8, table_sheet[7]
  table_sheet.insert_row 9, table_sheet[7]
  table_sheet.insert_row 10, table_sheet[7]
  table_sheet.clone

  operations = Shoxcel::Operation.create direction["operations"]
  operations.each do |operation|
    operation.exec book
  end

  book.save_as './output.xlsx'
end