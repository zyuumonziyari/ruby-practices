# frozen_string_literal: true

require_relative 'option'
require_relative 'basic_ls_command'
require_relative 'detailed_ls_command'

options = Option.new
files = Dir.entries(Dir.pwd)
filterd_files = options.show_hidden? ? files : files.reject { |entry| entry.start_with?('.') }
sorted_files = options.reverse_sort? ? filterd_files.sort.reverse : filterd_files.sort
options.show_long_format? ? DetailedLsCommand.new(sorted_files).output : BasicLsCommand.new(sorted_files).output
