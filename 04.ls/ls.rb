# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3

options = { show_permission: false }
opt = OptionParser.new
opt.on('-l') { options[:show_permission] = true }
opt.parse!(ARGV)

def count_block_num(file_names)
  blocksize = 8192
  total_block_num = 0
  file_names.each do |file_name|
    fs = File::Stat.new(file_name)
    block_num = (fs.size / blocksize.to_f).ceil
    total_block_num += block_num * 8
  end
  puts "total #{total_block_num}"
end

def output_l_option(file_names)
  title_max_length = 0
  file_names.each do |file_name|
    fs = File::Stat.new(file_name)
    title_length = fs.size.to_s.length
    title_max_length = [title_max_length, title_length].max
    permissions = mode_to_permission(fs.mode)
    owner = Etc.getpwuid(fs.uid).name
    group = Etc.getgrgid(fs.gid).name
    size = fs.size
    mtime = fs.mtime.strftime('%m %d %H:%M')
    basename = File.basename(file_name)
    puts "#{permissions}  #{fs.nlink} #{owner}  #{group}  #{size.to_s.rjust(title_max_length)} #{mtime} #{basename}"
  end
end

def mode_to_permission(mode)
  perms = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => '-rw-',
    '7' => '-rwx'
  }
  mode.to_s(8)[-3..].chars.map { |digit| perms[digit] }.join
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

file_names = Dir.entries(Dir.pwd)
file_names = file_names.sort
file_names = file_names.reject { |entry| entry.start_with?('.') }

if options[:show_permission]
  count_block_num(file_names)
  output_l_option(file_names)
else
  output_current_directories(file_names)
end
