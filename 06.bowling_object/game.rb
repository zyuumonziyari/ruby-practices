# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  LAST_FRAME = 9

  def initialize(marks)
    @frames = []
    0.upto(9) do |frame_idx|
      frame = Frame.new(frame_idx)
      frame.add_shot(marks)
      @frames << frame
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
