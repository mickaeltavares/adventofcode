# frozen_string_literal: true

class Lanternfish
  def initialize(number)
    @number = number
  end

  def decrease
    @number -= 1
    if @number == -1
      @number = 6
      return true
    end
    false
  end
end

line = File.readlines('lanternfish.txt').first
initial_states = line.split(',')
lfs = []
initial_states.each { |i| lfs.push(i.to_i) }
gens = Hash.new(0)
initial_states.each { |i| gens[i.to_i] += 1 }
pp gens

256.times do
  newgens = Hash.new(0)
  gens.each do |k, v|
    if k == 0
      newgens[8] += v
      newgens[6] += v
    else
      newgens[k - 1] += v
    end
  end
  pp newgens
  gens = newgens
end

pp gens.values.sum(0)
