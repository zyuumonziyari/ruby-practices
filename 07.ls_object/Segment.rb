# frozen_string_literal: true

require 'minitest/autorun'

class Segment
  require_relative 'format'

  def initialize(option, segments)
    @option = option
    @segments = sort_segments(filter_hidden_segments(segments))
  end

  def output
    Format.new(@segments).output
  end

  private

  def filter_hidden_segments(segments)
    @option.show_hidden? ? segments : segments.reject { |entry| entry.start_with?('.') }
  end

  def sort_segments(segments)
    @option.reverse_sort? ? segments.sort.reverse : segments.sort
  end
end
