
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

  attr_accessor :grid, :t_grid, :dimensions, :max_scenic_score
  attr_reader :row, :col
  # visible[] holds the coordinates of trees that are visible
  attr_reader :visible

  def initialize(length_of_side)
    @grid = []
    @grid = initialize_row(length_of_side)
    @grid.map! { initialize_row(length_of_side) }
    @visible = Set.new
    @dimensions = [@grid.size, @grid[0].size]
    @max_scenic_score = 0
  end

  def initialize_row(length_of_side)
    row = Array.new(length_of_side)
  end

  def load_row(row, txt)
    arr = txt.strip.chars.map { |t| t.to_i }
    @grid[row] = @grid[row] && arr
  end

  def transpose_grid
    @t_grid = @grid.transpose
  end

  def row(index)
    @grid[index]
  end

  def col(index)
    # Be sure transpose_grid has been called first
    transpose_grid if @t_grid.nil?
    @t_grid[index]
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
      list = list.reverse
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

  def display_grid
    text_lines = []
    grid.each do |row|
      text = '|'
      row.each do |tree|
        text += " %1d |" % [tree]
      end
      text_lines << text
    end
    puts text_lines.join("\n")

  end

  # Stop if you reach an edge or at the first tree that is the same height or taller
  # than the tree under consideration
  def find_scenic_in_list(list)
    debug = false
    items_found = []
    current_height = list[0]
    # puts "Counting trees until we find one that is >= #{current_height} in '#{list.join}'" if debug
    puts list.join if debug
    list.each_with_index do |height, i|
      next if i == 0
      delta = height - current_height
      # puts "∆: #{delta} for #{height}" if debug
      if delta == 0
        # if the height is the same, add it & stop looking
        puts "∆: #{delta} for #{height} --> add #{height}" if debug
        items_found << height
        break
      elsif delta > 0
        # if the height is higher, add it & stop looking
        puts "∆: #{delta} for #{height} --> add #{height}" if debug
        items_found << height
        break
      elsif delta < 0
        # if the height is lower, add it and keep looking
        puts "∆: #{delta} for #{height} --> add #{height}" if debug
        items_found << height
      end
    end

    items_found
  end

  def scenic_trees(start,arr)
    scenic = []
    looking_left = arr.slice(0..(start)).reverse
    scenic << self.find_scenic_in_list(looking_left).size

    looking_right = arr.slice((start)..(arr.size-1))
    scenic << self.find_scenic_in_list(looking_right).size
    scenic
  end

  # Compute the score for tree at [row, col] in the grid
  # The score is based on the number of trees visible in all 4 directions.
  # Stop if you reach an edge or at the first tree that is the same height or taller
  # than the tree under consideration
  def compute_scenic_score(row,col)
    # puts "Tree at [#{row},#{col}], height of #{row(row)[col]}"
    # Combine the score in the current row and column
    list = scenic_trees(col,row(row))
    list += scenic_trees(row,col(col))

    scenic_score = 1
    list.each do |h|
      next if h == 0
      scenic_score = scenic_score*h
    end
    # puts "#{scenic_score} for #{list.inspect}"
    scenic_score
  end

  def find_max_scenic_score
    @max_scenic_score = 0
    rows = @dimensions[0] - 1
    cols = @dimensions[1] - 1
    text_lines = []
    # puts "Scoring a #{rows+1}x#{cols+1} matrix"
    (1..rows-1).each do |r|
      list = row(r)
      text = '|'
      (1..cols-1).each do |col|
        tree = list[col]
        score = compute_scenic_score(r,col)
        text += "%4d|" % score
        if score > @max_scenic_score
          @max_scenic_score = score
        end
      end
      text_lines << text
    end
    # puts text_lines.join("\n")
    puts "Max Scenic Score #{@max_scenic_score}"
  end

  def self.process(file_name)
    grove = nil
    lines = 0
    File.readlines("#{file_name}").each_with_index do |contents, i|
      next if contents.strip.empty?
      if i == 0
        # puts "Build new grid(#{contents.strip.size}) for '#{contents.strip}'"
        grove = Grid.new(contents.strip.size)
        # puts grove.dimensions.inspect
      end
      grove.load_row(i, contents.strip)
      # puts grove.grid[0].inspect if i == 0
      lines += 1
    end
    puts "#{lines} lines processed"

    grove.transpose_grid # for column access

    grove.grid.each_with_index{|r,i| grove.find_visible_in_row(i)}
    grove.grid.each_with_index{|r,i| grove.find_visible_in_col(i)}

    grove.find_max_scenic_score
    grove
  end

end
