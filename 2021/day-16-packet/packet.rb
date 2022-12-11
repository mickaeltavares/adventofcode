# frozen_string_literal: true

require "test/unit/assertions"
include Test::Unit::Assertions

TABLE = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111',
}

def hex2bin(hexa)
  hexa.chars.map { |h| TABLE[h] }.join
end

def cut(bin_packet, result = { versions: [], type_ids: [], values: [], remainder: bin_packet })
  version = bin_packet[0...3].to_i(2)
  result[:versions].push(version)
  type_id = bin_packet[3...6].to_i(2)
  result[:type_ids].push(type_id)
  if type_id == 4
    rest = bin_packet[6..-1]
    code = ''
    idx = 0
    rest.scan(/.{5}/).each do |a|
      code += a[1..-1]
      idx += 5
      if a[0] == '0'
        break
      end
    end
    result[:values].push(code.to_i(2))
    result[:remainder] = rest[idx..-1]
    result
  else
    result1 = result
    length_type_id = bin_packet[6]
    if length_type_id == '0'
      result2 = result1
      length = bin_packet[7, 15].to_i(2)
      sub_packets = bin_packet[7 + 15, length]
      while sub_packets.length > 0
        result2 = cut(sub_packets, result2)
        sub_packets = result2[:remainder]
      end
      result2[:remainder] = bin_packet[(7 + 15 + length)..-1]
      parse_n_bits_value = result2
      result1 = parse_n_bits_value
    else
      result2 = result1
      nb_sub_packets = bin_packet[7, 11].to_i(2)
      sub_packets = bin_packet[(7 + 11)..-1]
      nb_sub_packets.times do
        result2 = cut(sub_packets, result2)
        sub_packets = result2[:remainder]
      end
      parse_n_subpackets_value = result2
      result1 = parse_n_subpackets_value
    end
    result1
  end
end

def cut2(bin_packet)
  version = bin_packet[0...3].to_i(2)
  type_id = bin_packet[3...6].to_i(2)
  bin_packet = bin_packet[6..]
  if type_id == 4
    code = ''
    while true
      continue = bin_packet[0]
      code += bin_packet[1...5]
      bin_packet = bin_packet[5..]
      break if continue == '0'
    end
    return [version, type_id, code.to_i(2), bin_packet]
  else
    packets = []
    length_type_id = bin_packet[0]
    bin_packet = bin_packet[1..]
    if length_type_id == '0'
      length = bin_packet[0...15].to_i(2)
      bin_packet = bin_packet[15..]
      sub_packets = bin_packet[0...length]
      bin_packet = bin_packet[length..]
      while sub_packets.length > 0
        result = cut2(sub_packets)
        sub_packets = result.last
        packets.push(result)
      end
    else
      nb_sub_packets = bin_packet[0...11].to_i(2)
      bin_packet = bin_packet[11..]
      nb_sub_packets.times do
        result = cut2(bin_packet)
        bin_packet = result.last
        packets.push(result)
      end
    end
    return [version, type_id, packets, bin_packet]
  end
end

assert_equal '110100101111111000101000', hex2bin('D2FE28')
expected = { versions: [6], type_ids: [4], values: [2021], remainder: '000' }
assert_equal expected, cut('110100101111111000101000')

assert_equal '00111000000000000110111101000101001010010001001000000000', hex2bin('38006F45291200')
expected = { versions: [1, 6, 2], type_ids: [6, 4, 4], values: [10, 20], remainder: '0000000' }
assert_equal expected, cut('00111000000000000110111101000101001010010001001000000000')

assert_equal '11101110000000001101010000001100100000100011000001100000', hex2bin('EE00D40C823060')
expected = { versions: [7,2,4,1], type_ids: [3,4, 4, 4], values: [1,2,3], remainder: '00000' }
assert_equal expected, cut('11101110000000001101010000001100100000100011000001100000')

assert_equal '110100101111111000101000', hex2bin('D2FE28')
assert_equal [6, 4, 2021, '000'], cut2('110100101111111000101000')

assert_equal '00111000000000000110111101000101001010010001001000000000', hex2bin('38006F45291200')
assert_equal [1, 6, [[6, 4, 10, "0101001000100100"], [2, 4, 20, ""]], "0000000"], cut2('00111000000000000110111101000101001010010001001000000000')

assert_equal '11101110000000001101010000001100100000100011000001100000', hex2bin('EE00D40C823060')
assert_equal [7, 3, [[2, 4, 1, "100100000100011000001100000"], [4, 4, 2, "0011000001100000"], [1, 4, 3, "00000"]], "00000"], cut2('11101110000000001101010000001100100000100011000001100000')

def sum_versions(hexa)
  bin_packet = hex2bin(hexa)
  result = cut(bin_packet)
  result[:versions].sum
end

def sum_versions_rec(result)
  version, type_id, sub_packets, _ = result
  if type_id == 4
    version
  else
    version + sub_packets.map { |sp| sum_versions_rec(sp) }.sum
  end
end

assert_equal 16, sum_versions('8A004A801A8002F478')
assert_equal 12, sum_versions('620080001611562C8802118E34')
assert_equal 23, sum_versions('C0015000016115A2E0802F182340')
assert_equal 31, sum_versions('A0016C880162017C3686B18A3D4780')

assert_equal 16, sum_versions_rec(cut2(hex2bin('8A004A801A8002F478')))
assert_equal 12, sum_versions_rec(cut2(hex2bin('620080001611562C8802118E34')))
assert_equal 23, sum_versions_rec(cut2(hex2bin('C0015000016115A2E0802F182340')))
assert_equal 31, sum_versions_rec(cut2(hex2bin('A0016C880162017C3686B18A3D4780')))

pp sum_versions(File.read('puzzle.txt'))
pp sum_versions_rec(cut2(hex2bin(File.read('puzzle.txt'))))

def parse(hexa)
  bin_packet = hex2bin(hexa)
  result = cut2(bin_packet)
  parse_rec(result)
end

def parse_rec(result)
  _, type_id, sub_packets, _ = result
  if type_id == 0
    return sub_packets.map { |sp| parse_rec(sp) }.sum
  elsif type_id == 1
    prod = 1
    sub_packets.each do |sp|
      prod *= parse_rec(sp)
    end
    return prod
  elsif type_id == 2
    return sub_packets.map { |sp| parse_rec(sp) }.min
  elsif type_id == 3
    return sub_packets.map { |sp| parse_rec(sp) }.max
  elsif type_id == 4
    return sub_packets
  elsif type_id == 5
    return parse_rec(sub_packets[0]) > parse_rec(sub_packets[1]) ? 1 : 0
  elsif type_id == 6
    return parse_rec(sub_packets[0]) < parse_rec(sub_packets[1]) ? 1 : 0
  elsif type_id == 7
    return parse_rec(sub_packets[0]) == parse_rec(sub_packets[1]) ? 1 : 0
  end
end

assert_equal 3, parse('C200B40A82')
assert_equal 54, parse('04005AC33890')
assert_equal 7, parse('880086C3E88112')
assert_equal 9, parse('CE00C43D881120')
assert_equal 1, parse('D8005AC2A8F0')
assert_equal 0, parse('F600BC2D8F')
assert_equal 0, parse('9C005AC2F8F0')
assert_equal 1, parse('9C0141080250320F1802104A08')

pp parse(File.read('puzzle.txt'))