# frozen_string_literal: true

require 'pqueue'
require 'set'

def neighbors(x, y, width, height)
  yield([x - 1, y]) if x.positive?
  yield([x + 1, y]) if x < width - 1
  yield([x, y - 1]) if y.positive?
  yield([x, y + 1]) if y < height - 1
end

def process(input)
  input = input.split(/\n/).map { |line| line.chars.map(&:to_i) }
  grid = 5.times.flat_map do |ny|
    input.map { |row| 5.times.flat_map { |nx| row.map { |risk| (risk + ny + nx - 1) % 9 + 1 } } }
  end
  target = [grid[0].size - 1, grid.size - 1]
  visited = Set[]
  queue = PQueue.new([[[0, 0], 0]]) { |a, b| a.last < b.last }
  until queue.empty?
    node, risk = queue.pop
    next unless visited.add?(node)
    return risk if node == target

    neighbors(*node, grid.first.size, grid.size) { |x, y| queue.push([[x,y], risk + grid[y][x]]) }
  end
end

puts process(File.read('puzzle.txt'))