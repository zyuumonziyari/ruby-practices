# frozen_string_literal: true

require_relative 'segment'
require_relative 'detail_segment'

class SegmentFactory
  def self.create(options, segments)
    options.show_long_format? ? DetailSegment.new(options, segments) : Segment.new(options, segments)
  end
end
