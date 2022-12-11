# frozen_string_literal: true

grid = Hash.new('.')
folds = []
File.readlines('example.txt').each do |line|
  line.strip!
  if line.start_with? "fold"
    folds.push line.split(" ")[2]
  elsif !line.empty?
    x, y = line.split(",")
    grid[[x.to_i, y.to_i]] = '#'
  end
end
pp grid
pp folds

def pretty_print(grid)
  nb_rows = grid.keys.max_by { |k| k[0] > k[1] ? k[0] : k[1] }.max
  (0..nb_rows).each do |y|
    (0..nb_rows).each do |x|
      print grid[[x,y]]
    end
    puts
  end
end

def fold_y(grid, value)
  new_grid = Hash.new('.')
  grid.each do |k, v|
    x, y = k
    if y > value
      new_grid[[x, 2 * value - y]] = v
    else
      new_grid[[x, y]] = v
    end
  end
  new_grid
end
def fold_x(grid, value)
  new_grid = Hash.new('.')
  grid.each do |k, v|
    x, y = k
    if x > value
      new_grid[[2 * value - x, y]] = v
    else
      new_grid[[x, y]] = v
    end
  end
  new_grid
end

def fold(grid, fold)
  xy, value = fold.split("=")
  (xy == 'x') ? fold_x(grid, value.to_i) : fold_y(grid, value.to_i)
end

# pretty_print grid
folds.each do |fold|
  grid = fold grid, fold
  # pretty_print grid
end
pp grid.length
pretty_print grid