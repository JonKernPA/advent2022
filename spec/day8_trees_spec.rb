$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'survey'
require 'grid'

require 'spec_helper'

RSpec.describe 'DAY 8: Treehouse Planning', type: :model do

  it 'has a grid' do
    length_of_side = 5
    grove = Grid.new(length_of_side)

    expect(grove.dimensions).to eql([length_of_side,length_of_side])

    grid = grove.grid
    expect(grid.size).to eql(length_of_side)
  end

  it 'loads rows' do
    grove = Grid.new(5)
    grove.load_row(0, '30373')
    grove.load_row(1, '25512')
    grove.load_row(2, '65332')
    grove.load_row(3, '33549')
    grove.load_row(4, '35390')

    grid = grove.grid
    expect(grid[0]).to eql([3,0,3,7,3])
    expect(grid[4]).to eql([3,5,3,9,0])
  end

  it 'loads long content' do
    sample = '000130010133444334124411122525303126205322331530363021562050544410330230535525023331433124342133030'
    grove = Grid.new(5)
    grove.load_row(0, sample)
    puts grove.grid.inspect
    expect(grove.grid[0].slice(0..9)).to eql([0,0,0,1,3,0,0,1,0,1])
  end

  context 'Part 1: looking for trees visible from the outside' do

    # R +---------+
    # 0 |3|0|3|7|3|
    # 1 |2|5|5|1|2|
    # 2 |6|5|3|3|2|
    # 3 |3|3|5|4|9|
    # 4 |3|5|3|9|0|
    #   +---------+
    # C: 0 1 2 3 4

    before :each do
      @grove = Grid.new(5)
      @grove.load_row(0, '30373')
      @grove.load_row(1, '25512')
      @grove.load_row(2, '65332')
      @grove.load_row(3, '33549')
      @grove.load_row(4, '35390')
      @grove.transpose_grid
    end

    it 'has a 2D grid' do
      expect(@grove.grid[0][0]).to eql(3)
      expect(@grove.grid[4][4]).to eql(0)
    end

    it 'has addressable rows' do
      expect(@grove.row(0)).to eql([3,0,3,7,3])
      expect(@grove.row(4)).to eql([3,5,3,9,0])
    end

    it 'has a transposed version of the grid' do
      expect(@grove.t_grid[0][0]).to eql(3)
      expect(@grove.t_grid[4][4]).to eql(0)
    end

    it 'has addressable columns' do
      expect(@grove.col(0)).to eql([3,2,6,3,3])
      expect(@grove.col(4)).to eql([3,2,2,9,0])
    end

    it 'finds visible trees in a given row' do
      # 1 |2|5|5|1|2|
      #    ^ ^ ^ _ ^
      @grove.find_visible_in_row(1)

      # All of the trees around the edge of the grid are visible
      expect(@grove.visible).to include([1,0],[1,4])
      # The top-left 5 is visible from the left
      # The top-middle 5 is visible from the top and right.
      # The top-right 1 is not visible from any direction;
      expect(@grove.visible).to include([1,1], [1,2])
      # Or in total
      expect(@grove.visible).to include([1, 0], [1,1], [1,2], [1,4])
    end

    it 'finds visible trees in a given column' do
      # 05535 (2nd column)
      # ^^__^
      @grove.find_visible_in_col(1)
      expect(@grove.visible).to include([0,1],[1,1],[4,1])
    end

  end

  it 'processes a test file' do
    grove = Grid.process('spec/test_input_day8.txt')
    expect(grove.dimensions).to eql([5,5])
    expect(grove.visible.size).to eql(21)
    expect(grove.visible).to include(
                              [0,0],[0,1],[0,2],[0,3],[0,4],
                              [1,0],[1,1],[1,2],      [1,4],
                              [2,0],[2,1],      [2,3],[2,4],
                              [3,0],[3,2],            [3,4],
                              [4,4],[4,1],[4,2],[4,3],[4,4],
                              )
  end

  it 'processes the input file' do
    grid = Grid.process('app/data/day8.txt')
    expect(grid.dimensions).to eql([99,99])
    puts "#{grid.visible.size} trees visible"
    expect(grid.visible.size).to eql(1679)
  end

  context 'Part 2: looking for tree with best scenic view' do

    # R +---------+
    # 0 |3|0|3|7|3|
    # 1 |2|5|5|1|2|
    # 2 |6|5|3|3|2|
    # 3 |3|3|5|4|9|
    # 4 |3|5|3|9|0|
    #   +---------+
    # C: 0 1 2 3 4

    before :each do
      @grove = Grid.new(5)
      @grove.load_row(0, '30373')
      @grove.load_row(1, '25512')
      @grove.load_row(2, '65332')
      @grove.load_row(3, '33549')
      @grove.load_row(4, '35390')
    end

    it 'count trees visible in each direction from a point in the sequence' do
      # 2nd Row
      # 1 |2|5|5|1|2|
      #      ^ * ^ ^
      expect(@grove.scenic_trees(2, [2,5,5,1,2])).to eql([1,2])

      # 3rd Column
      # 2 |3|5|3|5|3|
      #    ^ * ^ ^
      expect(@grove.scenic_trees(1, [3,5,3,5,3])).to eql([1,2])

      # 0 |3|0|3|7|3|
      expect(@grove.scenic_trees(3, [3,0,3,7,3])).to eql([3,1])

    end

    it 'finds scenic view score for a given tree' do
      # 1 |2|5|5|1|2|
      expect(@grove.compute_scenic_score(1,2)).to eql(4)
      # 3 |3|3|5|4|9|
      expect(@grove.compute_scenic_score(3,2)).to eql(8)
    end

    it 'compute all scenic scores, find max' do
      puts "Line #{__LINE__ }"
      puts @grove.display_grid
      puts '='*35
      @grove.find_max_scenic_score
      expect(@grove.max_scenic_score).to eql(8)
    end

    it 'processes a test file' do
      grove = Grid.process('spec/test_input_day8.txt')
      expect(grove.max_scenic_score).to eql(8)
    end

    it 'processes the input file' do
      grove = Grid.process('app/data/day8.txt')
      expect(grove.max_scenic_score).to eql(536625)
    end

  end

end
