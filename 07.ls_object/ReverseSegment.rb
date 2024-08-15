# frozen_string_literal: true

class ReverseSegment < Segment
  def output
    @files.reject { |entry| entry.start_with?('.') }.reverse
    super
  end
end
