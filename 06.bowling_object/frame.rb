# frozen_string_literal: true

require_relative 'shot'

class Frame
  MAX_SHOTS_IN_LAST_FRAME = 3
  MAX_SHOTS_IN_REGULAR_FRAME = 2

  attr_reader :scores, :frame_idx

  def initialize(frame_idx)
    @scores = []
    @frame_idx = frame_idx
  end

  def add_shot(marks, score_idx)
    loop do
      @scores << Shot.new(marks[score_idx])
      score_idx += 1
      break if complete?
    end
    score_idx
  end

  def score(frames)
    @scores.sum(&:score) + bonus_score(frames)
  end

  private

  def complete?
    if @frame_idx != Game::LAST_FRAME
      strike? || @scores.size == MAX_SHOTS_IN_REGULAR_FRAME
    else
      @scores.size == MAX_SHOTS_IN_LAST_FRAME || (@scores.size == MAX_SHOTS_IN_REGULAR_FRAME && !strike? && !spare?)
    end
  end

  def bonus_score(frames)
    next_frame = frames[frame_idx + 1]
    second_next_frame = frames[frame_idx + 2]

    return 0 if !next_frame

    if strike?
      strike_bonus(next_frame, second_next_frame)
    elsif spare?
      spare_bonus(next_frame)
    else
      0
    end
  end

  def strike?
    @scores.first.strike?
  end

  def spare?
    !strike? && @scores[0..1].sum(&:score) == 10
  end

  def strike_bonus(next_frame, second_next_frame)
    bonus = next_frame.scores.first.score
    if next_frame.scores.size > 1
      bonus += next_frame.scores[1].score
    elsif second_next_frame
      bonus += second_next_frame.scores.first.score
    end
    bonus
  end

  def spare_bonus(next_frame)
    next_frame.scores.first.score
  end
end
