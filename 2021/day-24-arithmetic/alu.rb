# frozen_string_literal: true

require "test/unit/assertions"
include Test::Unit::Assertions

prog1 = ['inp x', 'mul x -1']
prog2 = ['inp z', 'inp x', 'mul z 3', 'eql z x']
prog3 = [
  'inp w',
  'add z w',
  'mod z 2',
  'div w 2',
  'add y w',
  'mod y 2',
  'div w 2',
  'add x w',
  'mod x 2',
  'div w 2',
  'mod w 2',
]

def exec(prog, *values)
  w, x, y, z = 0, 0, 0, 0
  prog.each do |stmt|
    tokens = stmt.strip.split
    case tokens[0]
    when 'inp'
      eval("#{tokens[1]} = #{values.shift}")
    when 'add'
      eval("#{tokens[1]} += #{tokens[2]}")
    when 'mul'
      eval("#{tokens[1]} *= #{tokens[2]}")
    when 'div'
      eval("#{tokens[1]} /= #{tokens[2]}")
    when 'mod'
      eval("#{tokens[1]} %= #{tokens[2]}")
    when 'eql'
      equal = eval("#{tokens[1]} == #{tokens[2]}")
      if equal
        eval("#{tokens[1]} = 1")
      else
        eval("#{tokens[1]} = 0")
      end
    end
  end
  [w, x, y, z]
end

assert_equal([0, -1, 0, 0], exec(prog1, 1))
assert_equal([0, 1, 0, 0], exec(prog2, 1, 1))
assert_equal([0, 3, 0, 1], exec(prog2, 1, 3))
assert_equal([1, 0, 1, 0], exec(prog3, 42))

prog = File.readlines('puzzle.txt').map(&:strip)

# D+3 == E
# C-4 == F
# G-6 == H
# I+5 == J
# K+2 == L
# B+7 == M
# A-7 == N
min_num = 1_000_000_000_000_000
max_num = 0
(8..9).each do |a|
  n = a - 7
  (1..2).each do |b|
    m = b + 7
    (5..9).each do |c|
      f = c - 4
      (1..6).each do |d|
        e = d + 3
        (7..9).each do |g|
          h = g - 6
          (1..4).each do |i|
            j = i + 5
            (1..7).each do |k|
              l = k + 2
              digits = [a,b,c,d,e,f,g,h,i,j,k,l,m,n]
              result = exec(prog, *digits)
              if result[3] == 0
                num = digits.join.to_i
                min_num = num if min_num > num
                max_num = num if max_num < num
              end
            end
          end
        end
      end
    end
  end
end
pp min_num
pp max_num

# 99999999999999.downto(41111111111111).each do |x|
#   next if x.to_s.include?('0') || x.to_s.length != 14
#   digits = x.to_s.chars.map(&:to_i)
#   # D+3 == E
#   next if digits[3] + 3 != digits[4]
#   # C-4 == F
#   next if digits[2] - 4 != digits[5]
#   # G-6 == H
#   next if digits[6] - 6 != digits[7]
#   # I+5 == J
#   next if digits[8] + 5 != digits[9]
#   # K+2 == L
#   next if digits[10] + 2 != digits[11]
#   # A-3 == M <= that's an error
#   next if digits[0] - 3 != digits[12]
#   # result = exec(prog, *digits)
#   # pp "#{x} => #{result}"
#   pp "#{x}"
#   # if result[3] == 0
#   #   break
#   # end
# end

# A - 3 == M        G - 6 == H
# ABCDEFGHIJKLMN   ABCDEFGHIJKLMN
# 4...........1.   ......71......
# 5...........2.   ......82......
# 6...........3.   ......93......
# 7...........4.   ..............
# 8...........5.   ..............
# 9...........6.   ..............
#
# D + 3 == E         I + 5 == J
# ABCDEFGHIJKLMN   ABCDEFGHIJKLMN
# ...14.........   ........16....
# ...25.........   ........27....
# ...36.........   ........38....
# ...47.........   ........49....
# ...58.........   ..............
# ...69.........   ..............
#
# C - 4 == F          K + 2 == L
# ABCDEFGHIJKLMN   ABCDEFGHIJKLMN
# ..5..1........   ..........13..
# ..6..2........   ..........24..
# ..7..3........   ..........35..
# ..8..4........   ..........46..
# ..9..5........   ..........57..
# ..............   ..........68..
# ..............   ..........79..