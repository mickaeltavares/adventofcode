# frozen_string_literal: true

grid = Hash.new
elf = 0
grid[0] = 0
File.readlines('calories.txt').each do |line|
  row = line.strip
  if row.empty?
    elf+=1
    grid[elf] = 0
  else
    grid[elf] += row.to_i
  end
end

pp grid
max_values = grid.values.max
kv = grid.max_by(&:last)
pp kv

grid.delete(kv.first)
kv2 = grid.max_by(&:last)
pp kv2

grid.delete(kv2.first)
kv3 = grid.max_by(&:last)
pp kv3

pp kv.last + kv2.last + kv3.last