# frozen_string_literal: true

grid = Hash.new
File.readlines('puzzle.txt').each_with_index do |line, line_number|
  row = line.strip.chars
  row.each_with_index do |value, y|
    grid[[line_number, y]] = value.to_i
  end
end

def increment_all_values(grid)
  grid.each do |k, v|
    grid[k] += 1
  end
  grid
end

def increment_adjacents(grid, k)
  x, y = k
  length = grid.keys.max_by { |a| a[0] }[0]

  grid[[x - 1, y - 1]] += 1 unless x == 0 || y == 0
  grid[[x - 1, y]] += 1 unless x == 0
  grid[[x - 1, y + 1]] += 1 unless x == 0 || y == length
  grid[[x, y - 1]] += 1 unless y == 0
  grid[[x, y + 1]] += 1 unless y == length
  grid[[x + 1, y - 1]] += 1 unless x == length || y == 0
  grid[[x + 1, y]] += 1 unless x == length
  grid[[x + 1, y + 1]] += 1 unless x == length || y == length
  grid
end

def pretty_print(grid)
  nb_rows = grid.keys.max_by { |k| k[0] }[0]
  (0..nb_rows).each do |x|
    (0..nb_rows).each do |y|
      print grid[[x, y]]
      print "\t"
    end
    puts
  end
  puts
end

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

def flash_grid(grid, flashed)
  new_grid = deep_copy grid
  grid.each do |k, v|
    if v > 9 and flashed[k] == false
      flashed[k] = true
      increment_adjacents(new_grid, k)
    end
  end
  new_grid
end

def flash(grid)
  flashed = Hash.new(false)
  # tant que grid continue d'avoir des valeurs sup à 9 qui n'ont pas déjà flashé, flash ces cellules
  until grid.select { |k, v| v > 9 && flashed[k] == false }.empty? do
    grid = flash_grid(grid, flashed)
  end
  flashed.each_key { |k| grid[k] = 0 }
  [grid, flashed.keys.length]
end

def step(grid)
  grid = increment_all_values grid
  grid, nb_flashes = flash grid
  pretty_print grid
  [grid, nb_flashes]
end

def repeat_step(grid, n)
  nb_flashes = 0
  pretty_print grid
  n.times do |iter|
    grid, flashes = step grid
    if flashes == 100
      puts "All flashed at step #{iter+1}"
      break
    end
    nb_flashes += flashes
  end
  pp nb_flashes
  grid
end

repeat_step grid, 1000