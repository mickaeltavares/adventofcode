# frozen_string_literal: true

require "test/unit/assertions"
include Test::Unit::Assertions

START_OF_PACKET_MARKER_LENGTH = 4
START_OF_MESSAGE_MARKER_LENGTH = 14

def find_marker(str, marker_length)
  score = marker_length
  chars = str.chars

  four_chars = chars.take(marker_length)
  while four_chars.uniq.length != marker_length
    chars.shift
    score += 1
    four_chars = chars.take(marker_length)
  end

  score
end


def find_start_of_packet_marker(str)
  find_marker(str, START_OF_PACKET_MARKER_LENGTH)
end

def find_start_of_message_marker(str)
  find_marker(str, START_OF_MESSAGE_MARKER_LENGTH)
end

assert_equal 7, find_start_of_packet_marker('mjqjpqmgbljsphdztnvjfqwrcgsmlb')
assert_equal 5, find_start_of_packet_marker('bvwbjplbgvbhsrlpgdmjqwftvncz')
assert_equal 6, find_start_of_packet_marker('nppdvjthqldpwncqszvftbrmjlhg')
assert_equal 10, find_start_of_packet_marker('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg')
assert_equal 11, find_start_of_packet_marker('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw')

puzzle = File.readlines('puzzle.txt', chomp: true).first
pp "Part 1: #{find_start_of_packet_marker(puzzle)}"

assert_equal 19, find_start_of_message_marker('mjqjpqmgbljsphdztnvjfqwrcgsmlb')
assert_equal 23, find_start_of_message_marker('bvwbjplbgvbhsrlpgdmjqwftvncz')
assert_equal 23, find_start_of_message_marker('nppdvjthqldpwncqszvftbrmjlhg')
assert_equal 29, find_start_of_message_marker('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg')
assert_equal 26, find_start_of_message_marker('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw')

pp "Part 2: #{find_start_of_message_marker(puzzle)}"