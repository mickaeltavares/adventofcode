# frozen_string_literal: true

line = File.readlines('crabs.txt').first
initial_states = line.split(',').map(&:to_i)
minmax = initial_states.minmax
pp initial_states

min_fuel = Float::INFINITY
(minmax[0]..minmax[1]).each do |position|
  puts "computing alignment to position #{position}"
  fuel = 0
  initial_states.each do |origin|
    spread = (origin - position).abs
    fuel += (spread * (spread+1)) / 2
  end

  if fuel < min_fuel
    puts "#{min_fuel} => #{fuel}"
    min_fuel = fuel
  end
end
pp min_fuel