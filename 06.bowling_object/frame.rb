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
      @scores << Shot.new(marks.shift)
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
    @scores.sum(&:score)
  end

  def strike?
    @scores.first.score == 10
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
