# encoding: utf-8

require 'java'

require_relative 'lib/shoxcel'


require 'yaml'

rule = YAML::load_file('./samples/db2/rule.yml')
data = YAML::load_file('./samples/db2/data.yaml')

books = {}
Dir.glob('./samples/db2/*.xlsx').each do |template_path|
  basename = File.basename(template_path)
  unless /^~\$/.match(basename)
    puts template_path, File.basename(template_path)
    books[basename.sub(/.xlsx$/, '')] = Shoxcel::Book.new(template_path)
  end
end

puts books

require_relative 'lib/shoxcel/book_template'

templates = Shoxcel::BookTemplate.create_templates(rule['books'])
Shoxcel::BookTemplate.apply(books, templates, data, './output')
# templates.each do |template|
#   template.load(books)
# end

# Shoxcel::Book.open './samples/db2/template.xlsx' do |book|
#   sheet = book['テーブル']
#   cell = sheet.find_cell_by_text('indexes_tl')
#   puts cell, cell.row_index, cell.column_index
#   sheet.insert_row(2, sheet[1])
#   puts cell, cell.row_index, cell.column_index
# end
