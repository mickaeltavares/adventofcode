# frozen_string_literal: true

require 'set'

paths = Hash.new { |h,k| h[k] = [] }
File.readlines('puzzle.txt').each do |line|
  x, y = line.strip.split("-")
  paths[x].push y
  paths[y].push x unless x == "start" || y == "end"
end

def visit(current_node, paths, stack, visited, extra)
  return [stack.join(',')] if current_node == 'end'

  result = []
  paths[current_node].each do |connected|
    next if connected == 'start' || (connected !~ /^[A-Z]/ && visited.include?(connected) && !extra)

    next_extra = extra && (connected =~ /^[A-Z]/ || !visited.include?(connected))
    result += visit(connected, paths, stack + [connected], visited + Set.new([connected]), next_extra)
  end
  result
end

pp paths
all_paths = visit('start', paths, ['start'], Set.new(['start']), true)
pp all_paths.uniq.length
=begin
    start
    /   \
c--A-----b--d
    \   /
     end
=end

