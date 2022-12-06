
class Cargo

  attr_accessor :stacks

  def initialize(cargo_lines)
    input = cargo_lines.split("\n").reverse!
    num_stacks = input.first.split(' ').last.to_i
    @stacks = Array.new(num_stacks) {Array.new()}

    input.delete_at(0)
    input.each do |line|
      load = line.scan(/(   |\[\w\]) ?/).flatten
      load.each_with_index do |crate, stack|
        next if crate.gsub(' ','').empty?
        begin
          unpacked = crate.gsub!('[','').gsub!(']','')
          @stacks[stack] << unpacked
        rescue => oops
          ap "'#{crate}'"
          ap unpacked
          puts oops
        end
      end
    end

  end

  def move(num, from_stack, to_stack)
    num.times.each do |i|
      moving = @stacks[from_stack - 1].pop
      @stacks[to_stack - 1] << moving
    end
  end

  def move_multiple(num, from_stack, to_stack)
    moving = @stacks[from_stack - 1].pop(num).flatten
    @stacks[to_stack - 1] += moving
  end

  def top_crates
    @stacks.map{|s| s.last}.join
  end

  def dump
    ap @stacks
  end

  def to_s
    max_crates = (@stacks.map {|s| s.size}).max
    output = Array.new(@stacks.size) { Array.new(max_crates, ' ') }

    @stacks.each_with_index do |s, i|
      s.each_with_index {|c,j| output[i][j] = c}
    end

    text = []
    i = 0
    output.each do |o|
      text << "S#{i+1}: |#{o.join}|"
      i += 1
    end
    text.join("\n")
  end

end

class CargoHold

  attr_accessor :cargo, :moves

  def initialize(file_name)
    cargo_lines = ""
    stacks_read = false
    @moves = []
    lines = 0
    File.readlines("#{file_name}").each do |contents|

      # a blank line demarcates the cargo hold from the moves
      if contents.strip.empty?
        stacks_read =  true
        @cargo = Cargo.new(cargo_lines)
        next
      end

      # Extract the cargo hold data from the moves
      if stacks_read
        @moves << contents.strip
      else
        # puts "'#{contents.gsub("\n",'')}'"
        cargo_lines += contents
      end
      lines += 1
    end
    puts "#{lines} lines processed, #{@cargo.stacks.size} stacks & #{@moves.size} moves"
  end

  def process_moves
    line = 10
    @moves.each_with_index do |move, i|
      line += 1
      num, from_stack, to_stack = move.scan(/move (\d+) from (\d+) to (\d+)/).flatten
      @cargo.move(num.to_i, from_stack.to_i, to_stack.to_i)
    end
  end

  def process_multiple_moves
    line = 10
    @moves.each_with_index do |move, i|
      line += 1
      num, from_stack, to_stack = move.scan(/move (\d+) from (\d+) to (\d+)/).flatten
      @cargo.move_multiple(num.to_i, from_stack.to_i, to_stack.to_i)
    end
  end

end
