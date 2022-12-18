#!/usr/bin/env ruby
# frozen_string_literal: true

ALPHA_TABLE = ('a'..'z').to_h { |l| [l, l.ord - 96] }.merge!(
  ('A'..'Z').to_h { |l| [l, l.ord - 38] }
)

def part1
  score = 0
  File.readlines('puzzle.txt', chomp: true).each do |line|
    x, y = line.chars.each_slice(line.length / 2).map(&:join)
    asd = x.chars.intersection(y.chars)
    score += ALPHA_TABLE[asd[0]]
  end
  score
end

pp "Part 1: #{part1}"

def part2
  score = 0
  lines = File.readlines('puzzle.txt', chomp: true)
  groups = lines.each_slice(3).to_a

  groups.each do |g|
    intersect = g[0].chars & g[1].chars & g[2].chars
    score += ALPHA_TABLE[intersect[0]]
  end

  score
end

pp "Part 2: #{part2}"
