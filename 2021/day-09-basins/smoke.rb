# frozen_string_literal: true
require 'set'

grid = []
File.readlines('input.txt').each do |line|
  col = line.strip.chars.map(&:to_i)
  grid.push(col)
end

pp grid
rows = grid.length
cols = grid[0].length

#part 1
lowest = []
basin_sizes = []
(0...rows).each do |x|
  (0...cols).each do |y|
    puts "#{x},#{y}=>#{grid[x][y]}"
    xy = grid[x][y]
    adjacents = []
    adjacents.push grid[x - 1][y] unless x == 0
    adjacents.push grid[x + 1][y] unless x == rows - 1
    adjacents.push grid[x][y - 1] unless y == 0
    adjacents.push grid[x][y + 1] unless y == cols - 1
    if adjacents.all? { |adj| adj > xy }
      lowest.push xy
      basin_size = 0
      basin_points = [[x,y]]
      already_encountered = Set[]
      until basin_points.empty?
        i, j = basin_points.shift
        if grid[i][j] != 9 and !already_encountered.include? [i, j]
          basin_size+=1
          basin_points.push [i - 1, j] unless i == 0
          basin_points.push [i + 1, j] unless i == rows - 1
          basin_points.push [i, j - 1] unless j == 0
          basin_points.push [i, j + 1] unless j == cols - 1
        end
        already_encountered.add [i, j]
      end
      basin_sizes.push basin_size
    end
  end
end
pp lowest.sum + lowest.length

pp basin_sizes.sort.reverse!.slice(0, 3).inject(:*)