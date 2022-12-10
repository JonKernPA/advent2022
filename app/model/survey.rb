class Survey

  attr_accessor :row, :max

  def initialize

  end

  def row=(txt)
    @row = txt.chars.map{|t| t.to_i}
    @max = @row.max
  end

  def left_index
    @row.index(max)
  end

  def right_index
    @row.reverse.index(max)
  end

  def self.find_visible(trees)
    list = trees.chars.map{|t| t.to_i}
    puts list.inspect
    max = list.max
    # Start looking from the left
    visible = Survey.find_visible_trees(list, max)

    visible
  end

  def self.find_visible_trees(list, tallest)
    visible = []
    last_tree = 0
    list.each_with_index do |t, i|
      # The first one is always visible
      if i == 0
        visible << t
        last_tree = t
        next
      end

      # if the height is increasing, the tree is visible
      delta = t - last_tree
      puts "∆: #{delta} for #{t}"

      if delta >= 1
        visible << t
      elsif delta == 0
        # if the height is flat, the tree is not visible
        # need to check the remaining trees from the other direction
        rem_list = list.slice(i + 1, list.size - 1)
        puts "==0: Look through the rest from the other direction:"
        puts rem_list.inspect
        visible += find_visible_trees(rem_list, tallest)
        break
      else
        # if the height is decreasing, the tree is not visible
        # need to check the remaining trees from the other direction
        rem_list = list.slice(i + 1, list.size - 1)
        puts "< 0: Look through the rest from the other direction:"
        puts rem_list.inspect
        visible += find_visible_trees(rem_list, tallest)
        break
      end
      last_tree = t
    end
    visible
  end
end
