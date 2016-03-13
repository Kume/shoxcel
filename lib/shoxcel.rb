# -*- coding: utf-8 -*-
require 'java'

Dir.glob(File.expand_path('../poi', __FILE__) + '/**/*.jar').each do |jar|
  puts jar
  require jar
end

java_import java.io.FileInputStream
java_import java.io.FileOutputStream
java_import org.apache.poi.ss.usermodel.WorkbookFactory
java_import org.apache.poi.ss.usermodel.DataFormatter
java_import org.apache.poi.ss.usermodel.Cell

require_relative 'shoxcel/book'
require_relative 'shoxcel/sheet'
require_relative 'shoxcel/row'
require_relative 'shoxcel/cell'

module Shoxcel
end