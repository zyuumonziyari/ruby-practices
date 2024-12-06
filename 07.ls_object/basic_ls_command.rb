# frozen_string_literal: true

class BasicLsCommand
  COLUMNS = 3

  def initialize(files)
    @files = files
    @max_rows = (@files.count / COLUMNS.to_f).ceil
  end

  def output
    puts format_rows
  end

  private

  def format_rows
    max_column_widths = calculate_max_column_widths
    (0...@max_rows).map do |row|
      row_values = (0...COLUMNS).map { |col| @files[row + col * @max_rows] }
      formatted_row = row_values.map.with_index { |value, col| value.nil? ? '' : value.ljust(max_column_widths[col]) }
      formatted_row.join(' ' * COLUMNS)
    end
  end

  def calculate_max_column_widths
    (0...COLUMNS).map do |col|
      column_values = (0...@max_rows).map { |row| @files[row + col * @max_rows] }
      column_values.compact.map(&:length).max || 0
    end
  end
end
