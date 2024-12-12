require 'spec_helper'

RSpec.describe "Day 1", type: :model do

  it 'Computes the difference between each list item' do
    input = %q{
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
    }
    left = []
    right = []
    input.split("\n").map do |line|
      row = line.split.map(&:to_i)
      if row.any?
        left << row[0]
        right << row[1]
      end
    end
    left = left.sort
    right = right.sort

    # Compute the difference between each list item
    diff_sum = 0
    left.each do |l|
      r = right.shift
      diff = (r - l).abs
      ap "#{r} - #{l} = #{diff}"
      diff_sum += diff
    end
    answer = diff_sum
    ap answer
    expect(answer).to eq(11)

  end

end
