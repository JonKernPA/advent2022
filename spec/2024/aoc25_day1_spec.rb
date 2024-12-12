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
    raw_locations = input
                      .split("\n")
                      .reject { |i| i.empty? || i == "" }
                      .map do |line|
      line.split.map(&:to_i)
    end

    left = raw_locations.map(&:first).sort
    right = raw_locations.map(&:last).sort

    # Compute the difference between each list item
    answer = left.zip(right).map do |l, r|
      (r - l).abs
    end.sum

    expect(answer).to eq(11)

  end

end
