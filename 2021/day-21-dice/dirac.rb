# frozen_string_literal: true

class DeterministicDice
  attr_reader :value

  def initialize
    @value = 0
  end

  def roll
    @value += 1
    # @value = 0 if @value >= 101
    (@value - 1) % 100 + 1
    # @value
  end
end

class Player
  attr_reader :score

  def initialize(num, position)
    @num = num
    @position = position
    @score = 0
  end

  def roll(dice)
    print "#{@position} > "
    3.times do
      v = dice.roll
      print "#{v}+"
      @position += v
    end
    puts " = #{@position}"
    # @position %= 10
    # @position = 1 if @position == 0
    @position = (@position - 1) % 10 + 1
    @score += @position
  end

  def to_s
    "P#{@num} > Position #{@position}  Score #{@score}"
  end
end

dice = DeterministicDice.new
p1 = Player.new(1, 1)
p2 = Player.new(2, 3)

=begin
step = 0
while true
  p1.roll dice
  pp p1.to_s
  step += 1
  if p1.score >= 1000
    break
  end
  p2.roll dice
  pp p2.to_s
  step += 1
  if p2.score >= 1000
    break
  end
end
pp step
pp step * 3 * [p1.score, p2.score].min
=end

def c
  list = []
  [1, 2, 3].each do |x|
    [1, 2, 3].each do |y|
      [1, 2, 3].each do |z|
        list << x+y+z
      end
    end
  end
  list
end

CACHE = {}

def u(p1, p2, s1 = 0, s2 = 0)
  key = [p1, p2, s1, s2]
  if CACHE.has_key?(key)
    return CACHE[key]
  end
  oc = [0, 0]
  c.each do |r|
    p1_ = p1 + r
    p1_ = (p1_ - 1) % 10 + 1
    s1_ = s1 + p1_
    if s1_ >= 21
      oc[0] += 1
    else
      dy, dx = u(p2, p1_, s2, s1_)
      oc[0] += dx
      oc[1] += dy
    end
  end
  CACHE[key] = oc
  return oc
end

pp u(1, 3).max