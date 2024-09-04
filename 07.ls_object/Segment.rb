# frozen_string_literal: true

class Segment
  require_relative 'format'

  def initialize(option, segments)
    @segments = filter_hidden_segments(option, segments)
  end

  def output
    Format.new(@segments).output
  end

  private

  def filter_hidden_segments(option, segments)
    fileterd_segments = option.show_hidden? ? segments : segments.reject { |entry| entry.start_with?('.') }
    sort_segments(option, fileterd_segments)
  end

  def sort_segments(option, segments)
    option.reverse_sort? ? segments.sort.reverse : segments.sort
  end
end
