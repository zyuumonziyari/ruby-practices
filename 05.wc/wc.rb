# frozen_string_literal: true

require 'optparse'

options = { show_lines_count: false, show_words_count: false, show_bytes_count: false, show_chars_count: false }
opt = OptionParser.new
opt.on('-l') { options[:show_lines_count] = true }
opt.on('-w') { options[:show_words_count] = true }
opt.on('-c') { options[:show_bytes_count] = true }
opt.on('-m') { options[:show_chars_count] = true }
opt.parse!(ARGV)
file_paths = ARGV
total_lines_count = 0
total_words_count = 0
total_bytes_count = 0
total_chars_count = 0

def alert_none_file_paths
  puts 'ファイルパスを指定してください。'
end

def file_statistics(file_path)
  file = File.open(file_path, 'r')
  file_content = file.read
  line_count = file_content.lines.size
  word_count = file_content.split(/\s+/).size
  byte_count = file_content.bytesize
  char_count = file_content.length
  file.close
  { line_count:, word_count:, byte_count:, char_count: }
end

def standard_output_statistics(content)
  line_count = content.lines.size
  word_count = content.split(/\s+/).size
  byte_count = content.bytesize
  char_count = content.length
  { line_count:, word_count:, byte_count:, char_count: }
end

def process_stdin(options)
  content = $stdin.read
  result = standard_output_statistics(content)
  print "\n"
  print "#{result[:line_count]} " if options[:show_lines_count]
  print "#{result[:word_count]} " if options[:show_words_count]
  print "#{result[:byte_count]} " if options[:show_bytes_count]
  print "#{result[:char_count]} " if options[:show_chars_count]
  print "\n"
end

if !$stdin.tty?
  process_stdin(options)
elsif file_paths.empty?
  alert_none_file_paths
elsif options[:show_lines_count] || options[:show_words_count] || options[:show_bytes_count] || options[:show_chars_count]
  file_paths.each do |file_path|
    result = file_statistics(file_path)
    total_lines_count += result[:line_count]
    total_words_count += result[:word_count]
    total_bytes_count += result[:byte_count]
    total_chars_count += result[:char_count]

    print "\n"
    print "#{result[:line_count]} " if options[:show_lines_count]
    print "#{result[:word_count]} " if options[:show_words_count]
    print "#{result[:byte_count]} " if options[:show_bytes_count]
    print "#{result[:char_count]} " if options[:show_chars_count]
    print "#{file_path} "
  end
  if file_paths.length > 1
    print "\n"
    print "#{total_lines_count} " if options[:show_lines_count]
    print "#{total_words_count} " if options[:show_words_count]
    print "#{total_bytes_count} " if options[:show_bytes_count]
    print "#{total_chars_count} " if options[:show_chars_count]
    print 'total'
    print "\n"
  end
else
  file_paths.each do |file_path|
    result = file_statistics(file_path)
    total_lines_count += result[:line_count]
    total_words_count += result[:word_count]
    total_bytes_count += result[:byte_count]
    print "\n#{result[:line_count]}  #{result[:word_count]}  #{result[:byte_count]}  #{file_path} "
  end
  print "\n#{total_lines_count}  #{total_words_count}  #{total_bytes_count}  total" if file_paths.length > 1
end
