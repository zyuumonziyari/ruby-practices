# frozen_string_literal: true

require_relative 'ls_command_helper'

class LsCommand
  extend LsCommandHelper
  class << self

  COLUMNS = 3
  
  def output(options, files)
    sorted_files = filter_hidden_files(options, files)
    puts format_rows(sorted_files)
  end

  private

  def format_rows(sorted_files)
    max_rows = (sorted_files.count / COLUMNS.to_f).ceil
    max_column_widths = calculate_max_column_widths(sorted_files, max_rows)
    (0...max_rows).map do |row|
      row_values = (0...COLUMNS).map { |col| sorted_files[row + col * max_rows] }
      formatted_row = row_values.map.with_index { |value, col| value.nil? ? '' : value.ljust(max_column_widths[col]) }
      formatted_row.join(' ' * COLUMNS)
    end
  end

  def calculate_max_column_widths(sorted_files, max_rows)
    (0...COLUMNS).map do |col|
      column_values = (0...max_rows).map { |row| sorted_files[row + col * max_rows] }
      column_values.compact.map(&:length).max || 0
    end
  end
end
end
