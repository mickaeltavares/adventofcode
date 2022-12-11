# frozen_string_literal: true

key_values = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}
syntax_score = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}
autocomplete_score = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}
value_keys = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

syntax_check_points = 0
autocompletions = []
File.readlines('input.txt').each do |line|
  stack = []
  corruption = false
  input = line.strip.chars
  input.each do |c|
    if key_values.values.include? c
      stack.push c
    elsif key_values[c] == stack.last
      stack.pop
    else
      corruption = "Expected #{value_keys[stack.last]}, but found #{c} instead"
      syntax_check_points += syntax_score[c]
      break
    end
  end
  if corruption
    puts "Line #{line.strip} is corrupted : #{corruption}"
  elsif !stack.empty?
    puts "Line #{line.strip} is incomplete"
    autocomplete_points = 0
    until stack.empty?
      c = stack.pop
      autocomplete_points = 5 * autocomplete_points + autocomplete_score[value_keys[c]]
    end
    autocompletions.push autocomplete_points
  end
end
pp syntax_check_points
pp autocompletions.sort!.slice(0, autocompletions.length / 2 + 1).last