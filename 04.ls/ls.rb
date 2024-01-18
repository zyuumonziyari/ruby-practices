# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
BLOCKSIZE = 8192
PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

options = { show_hidden: false, reverse_sort: false, show_long_format: false }
opt = OptionParser.new
opt.on('-a') { options[:show_hidden] = true }
opt.on('-r') { options[:reverse_sort] = true }
opt.on('-l') { options[:show_long_format] = true }
opt.parse!(ARGV)

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

def output_block_num(file_names)
  total_block_num = 0
  file_names.each do |file_name|
    fs = File::Stat.new(file_name)
    block_num = (fs.size / BLOCKSIZE.to_f).ceil
    total_block_num += block_num * 8
  end
  puts "total #{total_block_num}"
end

def output_l_option(file_names)
  title_max_length = 0
  link_max_length = 0
  file_names.each do |file_name|
    fs = File::Stat.new(file_name)
    title_length = fs.size.to_s.length
    title_max_length = [title_max_length, title_length].max
    link_length = fs.nlink.to_s.length
    link_max_length = [link_max_length, link_length].max
    permissions = mode_to_permission(fs.mode)
    owner = Etc.getpwuid(fs.uid).name
    group = Etc.getgrgid(fs.gid).name
    mtime = fs.mtime.strftime('%m %d %H:%M')
    basename = File.basename(file_name)
    if File.directory?(file_name)
      puts "d#{permissions}  #{fs.nlink.to_s.rjust(link_max_length)} #{owner}  #{group}  #{fs.size.to_s.rjust(title_max_length)} #{mtime} #{basename}"
    else
      puts "-#{permissions}  #{fs.nlink.to_s.rjust(link_max_length)} #{owner}  #{group}  #{fs.size.to_s.rjust(title_max_length)} #{mtime} #{basename}"
    end
  end
end

def mode_to_permission(mode)
  mode.to_s(8)[-3..].chars.map { |digit| PERMISSIONS[digit] }.join
end

file_names = Dir.entries(Dir.pwd)
file_names = file_names.reject { |entry| entry.start_with?('.') } unless options[:show_hidden]
file_names = file_names.sort
file_names = file_names.reverse if options[:reverse_sort]
if options[:show_long_format]
  output_block_num(file_names)
  output_l_option(file_names)
else
  output_current_directories(file_names)
end
