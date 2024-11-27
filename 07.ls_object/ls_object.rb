# frozen_string_literal: true

require_relative 'option'
require_relative 'file_factory'

options = Option.new
files = Dir.entries(Dir.pwd)
FileFactory.create(options, files).output
