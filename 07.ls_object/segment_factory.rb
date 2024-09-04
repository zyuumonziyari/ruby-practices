# frozen_string_literal: true

class SegmentFactory
  require_relative 'option'
  require_relative 'segment'
  require_relative 'detail_segment'

  def self.create(options, segments)
    options.show_long_format? ? DetailSegment.new(options, segments) : Segment.new(options, segments)
  end
end

options = Option.new
segments = Dir.entries(Dir.pwd)
SegmentFactory.create(options, segments).output
