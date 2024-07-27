# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  LAST_FRAME = 10

  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def score
    @shots.sum(&:score)
  end

  def strike?
    @shots.first.strike?
  end

  def spare?
    @shots[0].score + @shots[1].score == 10
  end
end
