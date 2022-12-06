class Receiver

  attr_accessor :packet_marker, :marker_start

  def initialize(file_name)
    lines = 0
    chars = 0
    @packet_marker = ''
    File.readlines("#{file_name}").each do |contents|
      chars += contents.chars.size
      @packet_marker = find_marker(contents)
      lines += 1
    end
    puts "#{chars} characters processed"

  end

  def find_marker(str)
    chars = str.chars
    processed = chars.slice!(0..2)
    set = Set.new(processed)
    chars.each_with_index do |c,i|
      processed << c
      set << c
      if set.size == processed.size
        # found packet!
        @marker_start = i + 4
        puts "Found after #{@marker_start} character"
        @packet_marker = processed.join
        return @packet_marker, @marker_start
      else
        processed.slice!(0)
        set = Set.new(processed)
      end

      # puts processed.inspect
      # puts set.inspect
    end
  end
end
