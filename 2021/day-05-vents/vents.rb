# frozen_string_literal: true

grid = Hash.new(0)
ln = 0
File.readlines('vents.txt').each do |line|
  ln += 1
  puts "Reading ln #{ln}..."
  splitline = line.strip.split(" -> ")
  x1y1 = splitline[0].split(",")
  x2y2 = splitline[1].split(",")
  x1 = x1y1[0].to_i
  y1 = x1y1[1].to_i
  x2 = x2y2[0].to_i
  y2 = x2y2[1].to_i

  if x1 == x2
    if y1 < y2
      (y1..y2).each do |y| grid[[x1, y]] += 1 end
    else
      (y2..y1).each do |y| grid[[x1, y]] += 1 end
    end
  elsif y1 == y2
    if x1 < x2
      (x1..x2).each do |x| grid[[x, y1]] += 1 end
    else
      (x2..x1).each do |x| grid[[x, y1]] += 1 end
    end
  else
    if x1 < x2
      if y1 < y2
        while x1 <= x2 do
          while y1 <= y2 do
            grid[[x1,y1]] += 1
            x1 += 1
            y1 += 1
          end
        end
      else
        while x1 <= x2 do
          while y1 >= y2 do
            grid[[x1,y1]] += 1
            x1 += 1
            y1 -= 1
          end
        end
      end
    else
      if y1 < y2
        while x1 >= x2 do
          while y1 <= y2 do
            grid[[x1,y1]] += 1
            x1 -= 1
            y1 += 1
          end
        end
      else
        while x1 >= x2 do
          while y1 >= y2 do
            grid[[x1,y1]] += 1
            x1 -= 1
            y1 -= 1
          end
        end
      end
    end
  end
end

def pretty_print(grid)
  (0..10).each do |x|
    (0..10).each do |y|
      print grid[[x,y]] == 0 ? '.' : grid[[x,y]]
    end
    puts
  end
end

puts grid.select { |k, v| v >= 2 }.count
pretty_print(grid)