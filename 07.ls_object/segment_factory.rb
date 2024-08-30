# frozen_string_literal: true

class SegmentFactory
  require_relative 'option'
  require_relative 'segment'
  require_relative 'detail_segment'

  def self.create(option, segments)
    option.show_long_format? ? DetailSegment.new(option, segments) : Segment.new(option, segments)
  end
end

option = Option.new
segments = Dir.entries(Dir.pwd)
SegmentFactory.create(option, segments).output
