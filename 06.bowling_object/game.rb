# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME = 10

  def initialize(marks)
    @frames = []
    frame_marks = []
    frame_idx = 0

    marks.each do |mark|
      frame_marks << mark
      if frame_idx + 1 != LAST_FRAME
        if frame_marks[1] || frame_marks.first == 'X'
          @frames << Frame.new(frame_marks)
          frame_marks = []
          frame_idx += 1
        end
      else
        @frames << Frame.new(frame_marks)
        frame_marks = []
      end
    end
  end

  def score
    game_score = 0
    frame_idx = 0

    @frames.each_with_index do |frame, index|
      game_score += frame.score
      next if frame_idx + 1 == LAST_FRAME

      if frame.strike?
        game_score += strike_bonus(index)
      elsif frame.spare?
        game_score += spare_bonus(index)
      end
      frame_idx += 1
    end
    game_score
  end

  def strike_bonus(index)
    bonus = 0
    next_frame = @frames[index + 1]
    if next_frame
      bonus += next_frame.shots.first.score
      if next_frame.shots[1]
        bonus += next_frame.shots[1].score
      else
        second_next_frame = @frames[index + 2]
        bonus += second_next_frame.shots.first.score if second_next_frame
      end
    end
    bonus
  end

  def spare_bonus(index)
    next_frame = @frames[index + 1]
    next_frame ? next_frame.shots.first.score : 0
  end
end

marks = ARGV[0].split(',')
puts Game.new(marks).score
