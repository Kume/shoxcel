# encoding: utf-8

require 'java'
require 'optparse'
require_relative 'lib/shoxcel'

require 'yaml'

opt = OptionParser.new

opt.on('--rule path')
opt.on('--outDir path')
opt.on('--templateDir path')
opt.on('--data path')


params = {}
opt.parse!(ARGV, into: params)
raise '引数 --rule を指定してください。' unless params[:rule]
raise '引数 --outDir を指定してください。' unless params[:outDir]
raise '引数 --templateDir を指定してください。' unless params[:templateDir]


rule = YAML::load_file(params[:rule])
if params[:data]
  data = YAML::load_file(params[:data])
else
  data = YAML::load(STDIN)
end

books = {}
Dir.glob(File.join(params[:templateDir], '*')).each do |template_path|
  basename = File.basename(template_path)
  if /.xlsx?$/.match(basename) && !/^~\$/.match(basename)
    books[basename.sub(/.xlsx$/, '')] = Shoxcel::Book.new(template_path)
  end
end


require_relative 'lib/shoxcel/book_template'

templates = Shoxcel::BookTemplate.create_templates(rule['books'])
Shoxcel::BookTemplate.apply(books, templates, data, params[:outDir])

