# encoding: utf-8

require 'java'

require_relative 'lib/shoxcel'


require 'yaml'

direction = YAML::load_file('./samples/db/direction.yaml')

Shoxcel::Book.open './samples/db/template.xlsx' do |book|
  book['表紙'][0][1].value = 'test'
  table_sheet = book['テーブル']
  table_sheet.insert_row 8, table_sheet[7]
  table_sheet.insert_row 9, table_sheet[7]
  table_sheet.insert_row 10, table_sheet[7]
  # table_sheet.clone

  data = {
      'description' => YAML::load_file('./samples/db/data1/description.yaml'),
      'tables' => YAML::load_file('./samples/db/data1/tables.yaml')
  }

  operations = Shoxcel::Operation.create direction["operations"], data
  operations.each do |operation|
    operation.exec book
  end

  book.save_as './output.xlsx'
end