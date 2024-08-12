# frozen_string_literal: true

require_relative 'shot'

class Frame
  LAST_FRAME = 9

  attr_reader :scores

  def initialize(frame_idx)
    @scores = []
    @frame_idx = frame_idx
  end

  def add_shot(marks)
    marks.each do |mark|
      @scores << Shot.new(mark)
      break if complete?
    end
    @scores.size
  end

  def score(frames)
    @scores.sum(&:score) + bonus_score(frames)
  end

  private

  def complete?
    if @frame_idx != LAST_FRAME
      strike? || @scores.size == 2
    else
      @scores.size == (strike? || spare? ? 3 : 2)

    end
  end

  def bonus_score(frames)
    next_frame = frames[@frame_idx + 1]
    second_next_frame = frames[@frame_idx + 2]

    return 0 if @frame_idx == LAST_FRAME

    if strike?
      strike_bonus(next_frame, second_next_frame)
    elsif spare?
      spare_bonus(next_frame)
    else
      0
    end
  end

  def strike?
    @scores[0].strike?
  end

  def spare?
    !strike? && @scores[0..1].sum(&:score) == 10
  end

  def strike_bonus(next_frame, second_next_frame)
    next_frame.scores[0].score + (next_frame.scores[1] || second_next_frame.scores[0]).score
  end

  def spare_bonus(next_frame)
    next_frame.scores[0].score
  end
end
