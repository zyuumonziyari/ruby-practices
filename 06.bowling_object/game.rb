# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME = 10

  def initialize(marks)
    @frames = []
    frame_idx = 0
    while frame_idx < LAST_FRAME
      frame = Frame.new(frame_idx)
      frame.add_shot(marks)
      @frames << frame
      frame_idx += 1
    end
  end

  def score
    @frames.sum do |frame|
      next_frame = @frames[frame.frame_idx + 1]
      second_next_frame = @frames[frame.frame_idx + 2]
      frame.score(next_frame, second_next_frame)
    end
  end
end

marks = ARGV[0].split(',')
puts Game.new(marks).score
