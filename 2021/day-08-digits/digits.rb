# frozen_string_literal: true

def is1(token)
  token.length == 2
end

def is7(token)
  token.length == 3
end

def is4(token)
  token.length == 4
end

def is235(token)
  token.length == 5
end

def is069(token)
  token.length == 6
end

def is8(token)
  token.length == 7
end

def extract_simple_digits(tokens)
  one = tokens.find { |token| is1(token) }
  four = tokens.find { |token| is4(token) }
  seven = tokens.find { |token| is7(token) }
  eight = tokens.find { |token| is8(token) }
  [one, four, seven, eight]
end

def find069(tokens, four, one)
  zero_six_nine = tokens.select { |token| is069(token) }
  nine = zero_six_nine.find { |token| (four.chars - token.chars).empty? }
  zero = zero_six_nine.reject { |token| token == nine }.find { |token| (one.chars - token.chars).empty? }
  six = zero_six_nine.find { |token| token != nine && token != zero }
  [zero, six, nine]
end

def find235(tokens, one, six)
  two_three_five = tokens.select { |token| is235(token) }
  three = two_three_five.find { |token| (one.chars - token.chars).empty? }
  five = two_three_five.find { |token| (token.chars - six.chars).empty? }
  two = two_three_five.find { |token| token != three && token != five }
  [two, three, five]
end

ones_fours_sevens_eights = 0
sum_values = 0
File.readlines('input.txt').each do |line|
  tokens, values = line.split(' | ').map { |s| s.split(' ') }

  # part 1
  ones_fours_sevens_eights += values.count { |token| is1(token) || is4(token) || is7(token) || is8(token) }

  # part 2
  one, four, seven, eight = extract_simple_digits(tokens)
  zero, six, nine = find069(tokens, four, one)
  two, three, five = find235(tokens, one, six)
  code = {
    zero.chars.sort.join => '0',
    one.chars.sort.join => '1',
    two.chars.sort.join => '2',
    three.chars.sort.join => '3',
    four.chars.sort.join => '4',
    five.chars.sort.join => '5',
    six.chars.sort.join => '6',
    seven.chars.sort.join => '7',
    eight.chars.sort.join => '8',
    nine.chars.sort.join => '9'
  }
  sum_values += values.map { |v| code[v.chars.sort.join] }.join.to_i
end
pp ones_fours_sevens_eights
pp sum_values