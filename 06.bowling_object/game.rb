# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    mark_idx = 0
    @frames = (0.upto(Frame::LAST_FRAME)).map do |frame_idx| 
      frame = Frame.new(frame_idx, marks[mark_idx..])
      mark_idx += frame.shots.size
      frame
    end
  end

  def score
    @frames.sum do |frame|
      frame.score(@frames)
    end
  end
end

marks = ARGV[0].split(',')
puts Game.new(marks).score
