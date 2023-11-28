# frozen_string_literal: true

LAST_FLAME = 10

shots = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
frame_idx = 0
total = 0
first_done = false

shots.each_with_index do |shot, i|
  if frame_idx + 1 != LAST_FLAME
    if shot == 10 && !first_done
      first_done = true
      total += shots[i, 3].sum
    elsif first_done && shots[i - 1, 2].sum == 10
      total += shots[i, 2].sum
    else
      total += shot
    end
    frame_idx += 1 if first_done
    first_done = !first_done
  else
    total += shot
  end
end
puts total
