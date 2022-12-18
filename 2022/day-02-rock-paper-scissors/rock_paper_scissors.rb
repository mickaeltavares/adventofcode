# frozen_string_literal: true

SELECTED_SCORE = {
  'X' => 1, # rock
  'Y' => 2, # paper
  'Z' => 3, # scissors
}

WINS = {
  'Y' => 'A',
  'Z' => 'B',
  'X' => 'C'
}

ROUND_SCORE = {
  win: 6,
  draw: 3,
  lose: 0,
}

def scoring_part1(x, y)
  if x == 'A' && y == 'Y' || x == 'B' && y == 'Z' || x == 'C' && y == 'X'
    6 + SELECTED_SCORE[y]
  elsif x == 'A' && y == 'X' || x == 'B' && y == 'Y' || x == 'C' && y == 'Z'
    3 + SELECTED_SCORE[y]
  elsif x == 'A' && y == 'Z' || x == 'B' && y == 'X' || x == 'C' && y == 'Y'
    0 + SELECTED_SCORE[y]
  else
    raise 'unknown configuration'
  end
end

def part1
  score = 0
  File.readlines('puzzle.txt').each do |line|
    x, y = line.strip.split(" ")
    score += scoring_part1(x, y)
  end
  score
end

def scoring_part2(x, y)
  # X = lose
  # Y = draw
  # Z = win
  if y == 'X' # lose
    score = 0
    if x == 'A'
      score + SELECTED_SCORE['Z']
    elsif x == 'B'
      score + SELECTED_SCORE['X']
    elsif x == 'C'
      score + SELECTED_SCORE['Y']
    end
  elsif y == 'Y' # draw
    score = 3
    if x == 'A'
      score + SELECTED_SCORE['X']
    elsif x == 'B'
      score + SELECTED_SCORE['Y']
    else
      score + SELECTED_SCORE['Z']
    end
  elsif y == 'Z' # win
    score = 6
    if x == 'A'
      score + SELECTED_SCORE['Y']
    elsif x == 'B'
      score + SELECTED_SCORE['Z']
    elsif x == 'C'
      score + SELECTED_SCORE['X']
    end
  else
    raise 'unknown configuration'
  end
end

def part2
  score = 0
  File.readlines('puzzle.txt').each do |line|
    x, y = line.strip.split(" ")
    score += scoring_part2(x, y)
  end
  score
end

pp "Part 1: #{part1}"
pp "Part 2: #{part2}"