# frozen_string_literal: true

class Segment
  require_relative 'format'
  
  def initialize(option, files)
    @option = option
    @files = prepare_files(files)
  end
  
  def prepare_files(files)
    sort_files(files)
    filter_hidden_files(sorted_files)
  end
  
  def sort_files(files)
    @option.reverse_sort? ? files.sort.reverse : files.sort
  end
  
  def filter_hidden_files(files)
    @option.show_hidden? ? files : files.reject { |entry| entry.start_with?('.') }
  end

  def output
    Format.new.output(@files)
  end
end
