class Receiver

  attr_accessor :packet_marker, :packet_start, :message_marker, :message_start

  def initialize(file_name)
    lines = 0
    chars = 0
    @packet_marker = ''
    File.readlines("#{file_name}").each do |contents|
      chars += contents.chars.size
      find_packet_marker(contents)
      find_message_start(contents)
      lines += 1
    end
    puts "#{chars} characters processed"

  end

  def find_packet_marker(str)
    @packet_marker, @packet_start = find_repeater(str, 4)
  end

  def find_message_start(str)
    @message_marker, @message_start = find_repeater(str, 14)
  end

  def find_repeater(str, num_distinct = 4)
    chars = str.chars
    processed = chars.slice!(0..(num_distinct-2))
    set = Set.new(processed)
    chars.each_with_index do |c,i|
      processed << c
      set << c
      if set.size == processed.size && set.size == num_distinct
        # found packet!
        repeat_start = i + num_distinct
        puts "Found after #{repeat_start} character"
        repeat_marker = processed.join
        return repeat_marker, repeat_start
      else
        processed.slice!(0)
        set = Set.new(processed)
      end

    end
  end
end
