# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :frame_idx

  def initialize(frame_idx)
    @shots = []
    @frame_idx = frame_idx
  end

  def add_shot(marks)
    loop do
      shot = Shot.new(marks.shift)
      @shots << shot.score
      break if complete?
    end
  end

  def score(next_frame, second_next_frame)
    total_score = base_score
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
    if @frame_idx + 1 != Game::LAST_FRAME
      strike? || @shots.size == 2
    else
      @shots.size == 3 || (@shots.size == 2 && !strike? && !spare?)
    end
  end

  def base_score
    @shots.sum
  end

  def strike?
    @shots.first == 10
  end

  def spare?
    !strike? && @shots[0..1].sum == 10
  end

  def strike_bonus(next_frame, second_next_frame)
    bonus = next_frame.shots.first
    if next_frame.shots.size > 1
      bonus += next_frame.shots[1]
    elsif second_next_frame
      bonus += second_next_frame.shots.first
    end
    bonus
  end

  def spare_bonus(next_frame)
    next_frame.shots.first
  end
end
