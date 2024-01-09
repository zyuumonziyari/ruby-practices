# frozen_string_literal: true

require 'optparse'

COLUMNS = 3

options = { show_hidden: false, reverse_sort: false }
opt = OptionParser.new
opt.on('-a') { options[:show_hidden] = true }
opt.on('-r') { options[:reverse_sort] = true }

opt.parse(ARGV)
def count_current_directories(show_hidden, reverse_sort)
  file_names = Dir.entries(Dir.pwd)
  file_names = file_names.reject { |entry| entry.start_with?('.') } unless show_hidden
  file_names = file_names.sort
  file_names = file_names.reverse if reverse_sort

  output_current_directories(file_names)
end

def output_current_directories(file_names)
  max_rows = (file_names.count / COLUMNS.to_f).ceil
  max_column_widths = (0...COLUMNS).map do |col|
    column_values = (0...max_rows).map { |row| file_names[row + col * max_rows] }
    column_values.compact.map(&:length).max || 0
  end
  max_rows.times do |row|
    row_values = (0...COLUMNS).map { |col| file_names[row + col * max_rows] }
    formatted_row = row_values.map.with_index { |value, col| value.nil? ? '' : value.ljust(max_column_widths[col]) }
    puts formatted_row.join(' ' * COLUMNS)
  end
end

count_current_directories(options[:show_hidden], options[:reverse_sort])
