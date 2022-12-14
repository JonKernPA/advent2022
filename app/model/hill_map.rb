# We represent the height map as a Grid
#
# R +---------------+
# 0 |S|a|b|q|p|o|n|m|
# 1 |a|b|c|r|y|x|x|l|
# 2 |a|c|c|s|z|E|x|k|
# 3 |a|c|c|t|u|v|w|j|
# 4 |a|b|d|e|f|g|h|i|
#   +---------------+
# C: 0 1 2 3 4 5 6 7
#
# The list of visible is a set of (row,col) coordinates
# The tree "9" in the 4th row is at [3,4]



class HillMap

  attr_accessor :grid, :starting_loc, :signal_loc, :rarest_letters

  def initialize
    @grid = []
    @starting_loc = []
    @signal_loc = []
  end

  def find_starting_loc()
    find_location('S')
  end

  def find_signal_loc()
    find_location('E')
  end

  def find_location(char)
    loc = []
    @grid.each_with_index do |elevations, i|
      col = elevations.index(char)
      puts elevations.inspect
      if col
        loc = [i, col]
        break
      end
    end
    loc
  end

  def find_rarest_letters
    counts = {}
    @rarest_letter = 'a'
    @grid.each do |row|
      row.each do |c|
        next if c == 'S' || c == 'E'
        if counts[c]
          counts[c] += 1
        else
          counts[c] = 1
        end
      end
    end
    ap counts
    fewest = counts.map{|k,v| v}.min
    rarest = []
    counts.each do |k,v|
      next if v > fewest
      rarest << k
    end
    @rarest_letters = rarest
    puts "#{@rarest_letters.inspect} at n=#{fewest}"
    @rarest_letters
  end

  def load_from_file(file_name)
    lines = 0
    File.readlines("#{file_name}").each_with_index do |contents, row|
      @grid[row] = contents.strip.chars.map { |t| t }
      lines += 1
    end
    puts "#{lines} lines processed"
    @starting_loc = find_starting_loc
    @signal_loc = find_signal_loc
  end

end
