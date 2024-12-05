# frozen_string_literal: true

require_relative 'option'
require_relative 'ls_command'
require_relative 'l_option'

options = Option.new
files = Dir.entries(Dir.pwd)
filterd_files = options.show_hidden? ? files : files.reject { |entry| entry.start_with?('.') }
sorted_files = options.reverse_sort? ? filterd_files.sort.reverse : filterd_files.sort
options.show_long_format? ? LOption.new(options, sorted_files).output : LsCommand.new(options, sorted_files).output
