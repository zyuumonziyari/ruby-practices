# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @frames = []
    mark_idx = 0
    0.upto(Frame::LAST_FRAME) do |frame_idx|
      frame = Frame.new(frame_idx)
      mark_idx += frame.add_shot(marks[mark_idx..-1])
      @frames << frame
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
