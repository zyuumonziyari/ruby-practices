# frozen_string_literal: true

require_relative 'shot'

class Frame
  LAST_FRAME = 9

  attr_reader :shots

  def initialize(frame_idx, marks)
    @frame_idx = frame_idx
    @shots = []
    marks.each do |mark|
      @shots << Shot.new(mark)
      break if shots_completed?
    end
  end

  def score(frames)
    @shots.sum(&:score) + bonus_score(frames)
  end

  private

  def shots_completed?
    if @frame_idx < LAST_FRAME
      strike? || @shots.size == 2
    else
      @shots.size == (strike? || spare? ? 3 : 2)
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
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots[0..1].sum(&:score) == 10
  end

  def strike_bonus(next_frame, second_next_frame)
    next_frame.shots[0].score + (next_frame.shots[1] || second_next_frame.shots[0]).score
  end

  def spare_bonus(next_frame)
    next_frame.shots[0].score
  end
end
