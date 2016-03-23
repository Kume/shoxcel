# encoding: utf-8

require 'java'

require_relative 'lib/shoxcel'


require 'yaml'

direction = YAML::load_file('./samples/db/direction.yaml')

Shoxcel::Book.open './samples/db/template.xlsx' do |book|

  data = Shoxcel::DataLoader.load('./samples/db/data1', direction['data'])

  operations = Shoxcel::Operation.create direction["operations"], data
  operations.each do |operation|
    operation.exec book
  end

  book.save_as './output.xlsx'
end