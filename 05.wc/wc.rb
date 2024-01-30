# frozen_string_literal: true

require 'optparse'

options = { show_line_count: false, show_word_count: false, show_byte_count: false }
opt = OptionParser.new
opt.on('-l') { options[:show_line_count] = true }
opt.on('-w') { options[:show_word_count] = true }
opt.on('-c') { options[:show_byte_count] = true }
opt.parse!(ARGV)
file_paths = ARGV

if !options[:show_line_count] && !options[:show_word_count] && !options[:show_byte_count]
  options[:show_line_count] = true
  options[:show_word_count] = true
  options[:show_byte_count] = true
end

def alert_none_file_paths
  puts 'ファイルパスを指定してください。'
end

def process_stdin(options)
  content = $stdin.read
  output_statistics(content, options)
end

def output_statistics(content, options)
  line_count = content.lines.size
  word_count = content.split(/\s+/).size
  byte_count = content.bytesize
  count_contents = { line_count:, word_count:, byte_count: }
  count_contents.each do |key, value|
    print " #{value} " if options[:"show_#{key}"]
  end
end

def output_multiple_statistics(total_counts, options)
  total_counts.each do |key, value|
    print " #{value}" if options[:"show_#{key}"]
  end
end

if !$stdin.tty?
  process_stdin(options)
elsif file_paths.empty?
  alert_none_file_paths
else
  total_counts = { line_count: 0, word_count: 0, byte_count: 0 }
  file_paths.each do |file_path|
    file_content = File.read(file_path)
    file_counts = output_statistics(file_content, options)
    total_counts.each_key do |key|
      total_counts[key] += file_counts[key] if options[:"show_#{key}"]
    end
    print " #{file_path}\n"
  end
  output_multiple_statistics(total_counts, options) if file_paths.length > 1
  print '  total'
end
