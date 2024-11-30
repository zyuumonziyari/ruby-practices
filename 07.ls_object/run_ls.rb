# frozen_string_literal: true

require_relative 'option'
require_relative 'ls_command'
require_relative 'l_option'

options = Option.new
files = Dir.entries(Dir.pwd)
options.show_long_format? ? LOption.output(options, files) : LsCommand.output(options, files)
