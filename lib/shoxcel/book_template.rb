require_relative './sheet_template'
require_relative './util'

module Shoxcel
  class BookTemplate
    def self.create_templates(source)
      source.map do |book|
        self.create(book)
      end
    end

    def self.create(definition)
      case definition['type']
      when 'map'
        return MapBookTemplate.new(definition)
      else
        return FixedBookTemplate.new(definition)
      end
    end

    def self.apply(books, book_templates, data, out_dir)
      book_templates.each do |book_template|
        book = books[book_template.name_from]
        raise "book #{book_template.name_from} not found." unless book

        book_template.apply(book, Util.make_template_data(data, data), data, out_dir)
      end
    end

    def initialize(definition)
      @name = definition['name']
      @sheets = definition['sheets'].map do |sheet|
        SheetTemplate.create(sheet)
      end
      @data = definition['data']
      @data_context = definition['data_context']
    end

    def name_from
      case @name
      when String
        return @name
      when Hash
        return @name['from']
      else
        raise "invalid book name #{@name}"
      end
    end
  end

  class FixedBookTemplate < BookTemplate
    def initialize(definition)
      super
    end

    def name_to
      case @name
      when String
        return @name
      when Hash
        return @name['to']
      else
        raise "invalid book name type #{@name}"
      end
    end

    def apply(book, data, global, out_dir)
      context = data['_c']
      data = @data ? data.dig(*@data.split('.')) : data['_d']
      template_data = Util.make_template_data(data, global, context: context)
      output_name = Mustache.render(name_to, template_data)
      output_book = book.clone
      SheetTemplate.apply(output_book, @sheets, template_data, global)
      output_book.save_as File.join(out_dir, output_name)
    end
  end

  class MapBookTemplate < BookTemplate
    def initialize(definition)
      super
    end

    def name_to
      case @name
      when Hash
        return @name['to']
      else
        raise "invalid book name type #{@name}"
      end
    end

    def apply(book, data, global, out_dir)
      data = @data ? data.dig(*@data.split('.')) : data['_d']
      Util.each_template_data(data, global, context_name: @data_context) do |template_data|
        output_name = Mustache.render(name_to, template_data)
        mapped_book = book.clone
        SheetTemplate.apply(mapped_book, @sheets, template_data, global)
        mapped_book.save_as File.join(out_dir, output_name)
      end
    end
  end
end
