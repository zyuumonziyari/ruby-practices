# frozen_string_literal: true

require 'optparse'
COLUMNS = 3

options = {}
OptionParser.new do |opts|
  opts.on('-f', '--folder [FOLDER]') do |folder|
    options[:folder] = folder
  end
end.parse!

def count_current_directories(options)
  @current_directories = Dir.entries(options[:folder]).reject { |entry| entry.start_with?('.') }.sort if options[:folder]
  @current_directories = Dir.entries(Dir.pwd).reject { |entry| entry.start_with?('.') }.sort
  @current_directories_numbers = @current_directories.count
end

def output_current_directories
  max_rows = (@current_directories_numbers / COLUMNS.to_f).ceil
  max_rows.times do |row|
    row_values = (0...COLUMNS).map { |col| @current_directories[row + col * max_rows] }.compact
    puts row_values.map { |value| value.ljust(20) }.join
  end
end

count_current_directories(options)
output_current_directories
