$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'hill_map'

require 'spec_helper'

RSpec.describe 'DAY 12: Hill Climbing', type: :model do

  it 'has a grid of steps' do
    grid = HillMap.new
    grid.load_from_file('spec/test_input_day12.txt')
    expect(grid.grid.size).to eql(5)
  end

  it 'and a starting location' do
    grid = HillMap.new
    grid.load_from_file('spec/test_input_day12.txt')
    expect(grid.starting_loc).to eql([0,0])
  end

  it 'and a best signal location' do
    grid = HillMap.new
    grid.load_from_file('spec/test_input_day12.txt')
    expect(grid.signal_loc).to eql([3,6])
  end

  it 'ranks the number of characters present' do
    grid = HillMap.new
    grid.load_from_file('spec/test_input_day12.txt')
    # grid.load_from_file('app/data/day12.txt')
    grid.find_rarest_letters
    expect(grid.rarest_letters).to include('z')

  end

end
