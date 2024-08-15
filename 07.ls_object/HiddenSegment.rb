# frozen_string_literal: true

class HiddenSegment < Segment
  def output
    @files
    super
  end
end
