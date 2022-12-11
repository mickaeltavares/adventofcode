# frozen_string_literal: true

require "test/unit/assertions"
include Test::Unit::Assertions

target_area = { x: 20..30, y: -10..-5 }

# MINX, MAXX, MINY, MAXY = 20, 30, -10, -5
MINX, MAXX, MINY, MAXY = 230, 283, -107, -57

def next_step(x, y, dx, dy)
  x += dx
  y += dy
  dx = if dx > 0
         dx - 1
       elsif dx < 0
         dx + 1
       else
         dx
       end
  dy -= 1
  [x, y, dx, dy]
end

assert_equal [7, 2, 6, 1], next_step(0, 0, 7, 2)
assert_equal [13, 3, 5, 0], next_step(7, 2, 6, 1)
assert_equal [18, 3, 4, -1], next_step(13, 3, 5, 0)

# dy = -MINY
# (1..MAXX).each do |dx|
#   x, y,dy = 0, 0, -MINY
#   p dx, dy
#   while y >= MINY and x <= MAXX
#     x,y,dx,dy = next_step(x, y, dx, dy)
#     if x.between?(MINX, MAXX) and y.between?(MINY,MAXY)
#       pp 'ok'
#     end
#   end
# end

require 'set'
def can_land_dx(step)
  total = Set[]
  (1...MAXX+1).each do |dx|
    x = 0
    odx = dx
    step.times do
      x += dx
      if dx > 0
        dx -= 1
      end
    end
    if x.between?(MINX, MAXX)
      total.add(odx)
    end
  end
  total
end

def steps_for_dy(dy)
  y = 0
  steps = 0
  valid = []
  while y >= MINY
    if y.between?(MINY, MAXY)
      valid << steps
    end
    y += dy
    dy -= 1
    steps += 1
  end
  valid
end

dy = -MINY
while dy > MINY
  steps = steps_for_dy(dy)
  pp steps
  if steps.any? { |step| can_land_dx(step) }
    pp (1...dy+1).sum
    break
  end
  dy -= 1
end

total = 0
(MINY-1..-MINY+1).each do |dy|
  iter = Set[]
  steps_for_dy(dy).each do |step|
    iter = iter | can_land_dx(step)
  end
  total += iter.length
end
pp total