# frozen_string_literal: true

mutations = Hash.new
polymer = Hash.new(0)
last_letter = ''
File.readlines('puzzle.txt').each_with_index do |line, line_number|
  if line_number == 0
    template = line.strip
    puts template
    char_array = template.chars
    last_letter = char_array[-1]
    char_array.each_cons(2) { |a| polymer[a] += 1 }
  elsif line_number > 1
    pair, synth = line.strip.split(" -> ")
    mutations[pair] = synth
  end
end
pp mutations
pp polymer

def step(polymer, mutations)
  next_polymer = Hash.new(0)
  polymer.each do |k, v|
    synthesized = mutations[k.join]
    puts synthesized
    next_polymer[[k[0], synthesized]] += v
    next_polymer[[synthesized, k[1]]] += v
  end
  next_polymer
end

def count_letters(polymer, last_letter)
  letters = Hash.new(0)
  polymer.each do |k, v|
    letters[k[0]] += v
  end
  letters[last_letter] += 1
  letters
end

40.times do
  polymer = step polymer, mutations
end
letters = count_letters polymer, last_letter
pp letters
pp letters.values.max - letters.values.min