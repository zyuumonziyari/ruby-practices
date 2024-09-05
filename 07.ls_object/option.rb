# frozen_string_literal: true

class Option
  require 'optparse'
  
  def initialize
    @options = default_options
    parse_options
  end

  def show_hidden?
    @options[:show_hidden]
  end
  
  def reverse_sort?
    @options[:reverse_sort]
  end
  
  def show_long_format?
    @options[:show_long_format]
  end
  
  private

  def default_options
    { show_hidden: false, reverse_sort: false, show_long_format: false }
  end

  def parse_options
    opt = OptionParser.new
    opt.on('-a') { @options[:show_hidden] = true }
    opt.on('-r') { @options[:reverse_sort] = true }
    opt.on('-l') { @options[:show_long_format] = true }
    opt.parse!(ARGV)
  end
end
