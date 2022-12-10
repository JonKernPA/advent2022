
# We represent the grove of trees as a Grid
#
# R +---------+
# 0 |3|0|3|7|3|
# 1 |2|5|5|1|2|
# 2 |6|5|3|3|2|
# 3 |3|3|5|4|9|
# 4 |3|5|3|9|0|
#   +---------+
# C: 0 1 2 3 4
#
# The list of visible is a set of (row,col) coordinates
# The tree "9" in the 4th row is at [3,4]

class Grid

  attr_accessor :grid, :t_grid, :dimensions
  attr_reader :row, :col
  # visible[] holds the coordinates of trees that are visible
  attr_reader :visible

  def initialize(length_of_side)
    @grid = []
    @grid = initialize_row(length_of_side)
    @grid.map! { initialize_row(length_of_side) }
    @visible = Set.new
    @dimensions = [@grid.size, @grid[0].size]
  end

  def initialize_row(length_of_side)
    row = Array.new(length_of_side)
  end

  def load_row(row, txt)
    arr = txt.strip.chars.map { |t| t.to_i }
    @grid[row] = @grid[row] && arr
    @t_grid = @grid.transpose
  end

  def row(index)
    @grid[index]
  end

  def col(index)
    t_grid[index]
  end

  def find_visible_in_col(index, reverse=false)
    @visible += find_visible_in_list(index, 'col', reverse)
  end

  def find_visible_in_row(index, reverse=false)
    @visible += find_visible_in_list(index, 'row', reverse)
  end

  def find_visible_in_list(index, type='row', reverse=nil)
    items_found = Set.new
    debug = false
    list = []
    if type == 'col'
      list = col(index)
    else
      list = row(index)
    end

    # When we are going through the list looking from the right,
    # simply reverse things and adjust the column number
    offset = 0
    if reverse
      list.reverse!
      puts '>>REV<< ' * 2 if debug
      offset = list.size - 1
    end
    puts '-' * list.size * 4 if debug
    puts list.inspect if debug

    tallest = list.max
    # -1 makes it easy for trees at the edge with height 0 to have a ∆ of 1
    last_tallest = -1
    list.each_with_index do |height, i|
      column = i
      if reverse
        column = offset - i
      end

      # if the height is increasing, the tree is visible
      delta = height - last_tallest
      puts "∆: #{delta} for #{height}" if debug

      if delta > 0
        puts "   including [#{column}, #{index}]" if debug
        if type == 'row'
          items_found << [index, column]
        else
          items_found << [column, index]
        end
        last_tallest = height
      elsif delta == 0 || delta < 0
        # if the height is staying the same or decreasing, the tree is not visible.
      else
        #  no op
      end
      # Stop if we have just found the tallest tree
      # And look from the other end if requested
      if height == tallest && !reverse.nil? && !reverse
        puts "Found tallest from the #{reverse ? 'RIGHT' : 'LEFT'}" if debug
        items_found += self.find_visible_in_list(index, type, true)
        break
      end
    end
    # puts "Found #{items_found.size} items"
    items_found
  end

  def visible
    @visible.to_a
  end

  def scenic_trees(start,arr)
    scenic = Set.new
    left = arr.slice(0..(start-1))
    puts left.inspect
    # scenic += self.find_visible_in_list(index, type='row', reverse=nil)
    right = arr.slice((start+1)..(arr.size-1))
    puts right.inspect
  end

  def compute_scenic_score(row,col)

  end

  def self.process(file_name)
    grid = nil
    lines = 0
    File.readlines("#{file_name}").each_with_index do |contents, i|
      next if contents.strip.empty?
      if i == 0
        puts "Build new grid(#{contents.strip.size}) for '#{contents.strip}'"
        grid = Grid.new(contents.strip.size)
        puts grid.dimensions.inspect
      end
      grid.load_row(i, contents.strip)
      lines += 1
    end
    puts "#{lines} lines processed"
    # puts grid.grid.inspect

    grid.grid.each_with_index{|r,i| grid.find_visible_in_row(i)}
    grid.t_grid.each_with_index{|c,i| grid.find_visible_in_col(i)}

    grid
  end

end
