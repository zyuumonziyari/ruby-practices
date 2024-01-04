# frozen_string_literal: true

COLUMNS = 3

def count_current_directories
  current_directories = Dir.entries(Dir.pwd).reject { |entry| entry.start_with?('.') }.sort
  output_current_directories(current_directories)
end

def output_current_directories(current_directories)
  max_rows = (current_directories.count / COLUMNS.to_f).ceil
  max_column_widths = (0...COLUMNS).map do |col|
    column_values = (0...max_rows).map { |row| current_directories[row + col * max_rows] }
    column_values.compact.map(&:length).max || 0
  end
  max_rows.times do |row|
    row_values = (0...COLUMNS).map { |col| current_directories[row + col * max_rows] }
    formatted_row = row_values.map.with_index { |value, col| value.nil? ? '' : value.ljust(max_column_widths[col]) }
    puts formatted_row.join(' ' * COLUMNS)
  end
end

count_current_directories
