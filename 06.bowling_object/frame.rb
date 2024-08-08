# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :scores, :frame_idx

  def initialize(frame_idx)
    @scores = []
    @frame_idx = frame_idx
  end

  def add_shot(marks)
    loop do
      shot = Shot.new(marks.shift)
      @scores << shot
      break if complete?
    end
  end

  def score(frames)
    total_score = base_score
    next_frame = frames[frame_idx + 1]
    second_next_frame = frames[frame_idx + 2]
    if next_frame
      if strike?
        total_score += strike_bonus(next_frame, second_next_frame)
      elsif spare?
        total_score += spare_bonus(next_frame)
      end
    end
    total_score
  end

  private

  def complete?
    if @frame_idx != Game::LAST_FRAME
      strike? || @scores.size == 2
    else
      @scores.size == 3 || (@scores.size == 2 && !strike? && !spare?)
    end
  end

  def base_score
    @scores.score.sum
  end

  def strike?
    @scores.first == 10
  end

  def spare?
    !strike? && @scores[0..1].sum == 10
  end

  def strike_bonus(next_frame, second_next_frame)
    bonus = next_frame.scores.first
    if next_frame.scores.size > 1
      bonus += next_frame.scores[1]
    elsif second_next_frame
      bonus += second_next_frame.scores.first
    end
    bonus
  end

  def spare_bonus(next_frame)
    next_frame.scores.first
  end
end
