# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map { |s| s == 'X' ? 10 : s.to_i }
frame_idx = 0
first_done = false
LAST_FLAME = 10
result = Array.new(LAST_FLAME, 0)

shots.each_with_index do |shot, i|
  if frame_idx + 1 != LAST_FLAME
    if shot == 10
      if !first_done
        first_done = true
        result[frame_idx] = shots[i, 3].sum
      else
        result[frame_idx] = shots[i, 2].sum
      end
    elsif shot + result[frame_idx] == 10
      result[frame_idx] = result[frame_idx] + shots[i, 2].sum
    else
      result[frame_idx] += shot
    end
    if first_done
      frame_idx += 1
      first_done = false
    else
      first_done = true
    end
  else
    result[frame_idx] += shot
  end
end
puts result.sum
