# frozen_string_literal: true

def is_fully_included?(range1, range2)
  a, b = range1.split('-').map(&:to_i)
  x, y = range2.split('-').map(&:to_i)

  (a <= x && y <= b) || (x <= a && b <= y)
end

def part1
  score = 0
  File.readlines('puzzle.txt', chomp: true).each do |line|
    range1, range2 = line.split(',')
    score += 1 if is_fully_included?(range1, range2)
  end
  score
end

pp "Part 1: #{part1}"

def is_overlapping?(range1, range2)
  a, b = range1.split('-').map(&:to_i)
  x, y = range2.split('-').map(&:to_i)

  (a <= x && x <= b) || (x <= a && a <= y)
end

def part2
  score = 0
  File.readlines('puzzle.txt', chomp: true).each do |line|
    range1, range2 = line.split(',')
    if is_overlapping?(range1, range2)
      # pp line
      score += 1
    end
  end
  score
end

pp "Part 2: #{part2}"