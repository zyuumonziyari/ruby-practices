# frozen_string_literal: true

class Segment
  require_relative 'format'

  def initialize(options, segments)
    @segments = filter_hidden_segments(options, segments)
  end

  def output
    Format.new(@segments).output
  end

  private

  def filter_hidden_segments(options, segments)
    fileterd_segments = options.show_hidden? ? segments : segments.reject { |entry| entry.start_with?('.') }
    sort_segments(options, fileterd_segments)
  end

  def sort_segments(options, segments)
    options.reverse_sort? ? segments.sort.reverse : segments.sort
  end
end
