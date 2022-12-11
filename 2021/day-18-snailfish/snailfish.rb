# frozen_string_literal: true

# [1,2]
# [[1,2],3]
# [9,[8,7]]
# [[1,9],[8,5]]
# [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
# [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
# [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]

require "test/unit/assertions"
include Test::Unit::Assertions
class Num
  attr_accessor :value, :left, :right, :leftmost, :rightmost, :parent, :side
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @leftmost = self
    @rightmost = self
    @parent = nil
  end
  def update_n
    # do nothing
  end
  def to_s
    value.to_s
  end
end
class Pair
  attr_accessor :parent, :side, :left, :right, :leftmost, :rightmost
  def initialize(left, right)
    @parent = nil
    @side = nil
    @left = left
    @right = right
    @leftmost = left.leftmost
    @rightmost = right.rightmost
    set_left(left)
    set_right(right)
  end

  def set_left(left)
    @left = left
    @left.parent = self
    @left.side = 0
    @leftmost = @left.leftmost
    @left.rightmost.right = @right.leftmost
  end
  def set_right(right)
    @right = right
    @right.parent = self
    @right.side = 1
    @rightmost = @right.rightmost
    @right.leftmost.left = @left.rightmost
  end
  def update_n
    @left.update_n
    @right.update_n
    @leftmost = @left.leftmost
    @rightmost = @right.rightmost
    @left.rightmost.right = @right.leftmost
    @right.leftmost.left = @left.rightmost
  end
  def to_s
    "[#{@left},#{@right}]"
  end
end

class Array
  def depth
    map { |element| element.depth + 1 }.max
  end
  def splittable
    any? { |element| element.splittable }
  end
end

class Object
  def depth
    0
  end
  def splittable
    self >= 10
  end
end

def convert(e)
  if e.is_a?(Array)
    Pair.new(convert(e[0]), convert(e[1]))
  else
    Num.new(e)
  end
end

def test_explode(v, k, d = 0)
  if k.is_a?(Num)
    return
  end
  if k.left.is_a?(Num) and k.right.is_a?(Num) and d >= 4
    k.left.left.value += k.left.value if k.left.left
    k.right.right.value += k.right.value if k.right.right
    if k.side == 0
      k.parent.set_left(Num(0))
    else
      k.parent.set_right(Num(0))
    v.update_n
    return true
    end
  end
  test_explode(v, k.left, d + 1) || test_explode(v, k.right, d + 1)
end

def test_split(v, k)
  if k.is_a?(Num)
    if k.value >= 10
      if k.side == 0
        k.parent.set_left(Pair(Num(k.value / 2), Num(-(-k.value / 2))))
      else
        k.parent.set_right(Pair(Num(k.value / 2), Num(-(-k.value / 2))))
      end
      v.update_n
      return true
    else
      return false
    end
  end
  test_split(v, k.left) || test_split(v, k.right)
end

def reduce(number)
  while true do
    if test_explode(number, number)
    elsif test_split(number, number)
    else
      break
    end
  end
end

def add(n1, n2)
  added = Pair.new(n1, n2)
  reduce(added)
end

def magnitude(number)
  if number.is_a?(Num)
    number.value
  else
    3 * magnitude(number.left) + 2 * magnitude(number.right)
  end
end

result = []

File.readlines('example.txt').each do |line|
  if result.empty?
    result = convert(eval(line.strip))
  else
    result = Pair.new(result, convert(eval(line.strip)))
    reduce(result)
  end
end

pp magnitude(result)
# assert_equal 0, 1.depth
# assert_equal 1, [1].depth
# assert_equal 2, [[1]].depth
# assert_equal 3, [[[1]]].depth
# assert_equal 4, [[[[1]]]].depth
# assert_equal 5, [[[[[1]]]]].depth
#
# assert_false 1.splittable
# assert_false 9.splittable
# assert 10.splittable
# assert [10].splittable
# assert [1,2,3,4,14].splittable
# assert [1,[2,3],4,[[14]]].splittable
#
# assert_equal [[1, 1], [1, 2]], add([1,1], [1,2])
# assert_equal [[1,2],[[3,4],5]], add([1,2],[[3,4],5])
# assert_equal [[7,8],[8,4]], add([7, 8], [8, 4])

# assert_equal [[[[0,9],2],3],4], explode([[[[[9,8],1],2],3],4])
# assert_equal [7,[6,[5,[7,0]]]], explode([7,[6,[5,[4,[3,2]]]]])
# assert_equal [[6,[5,[7,0]]],3], explode([[6,[5,[4,[3,2]]]],1])
# assert_equal [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]], explode([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
# assert_equal [[3,[2,[8,0]]],[9,[5,[7,0]]]], explode([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])