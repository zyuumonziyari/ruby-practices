# frozen_string_literal: true

require_relative 'option'
require_relative 'segment_factory'

options = Option.new
segments = Dir.entries(Dir.pwd)
SegmentFactory.create(options, segments).output
