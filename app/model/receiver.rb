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
    @packet_marker, @packet_start = find_unique(str, 4)
  end

  def find_message_start(str)
    @message_marker, @message_start = find_unique(str, 14)
  end

  # Look for the first occurrence of a string of unique characters of the specified length
  def find_unique(str, desired_length)
    # Given a long slew of characters
    chars = str.chars

    # pre-load the first few characters, and take them out of the list
    # This list will remain at the "desired_length" in size
    processed = chars.slice!(0..(desired_length-2))

    # Use a Set as it removes duplicates chars (one of our rules)
    set = Set.new(processed)

    # Iterate through the rest of the list, one character at a time
    chars.each_with_index do |c,i|
      # Add it to the list & the set
      processed << c
      set << c

      # Check if the current list and the set are identical
      # --> implying a unique list has been detected
      if set.size == processed.size && set.size == desired_length
        repeat_start = i + desired_length
        puts "Found after #{repeat_start} character"
        repeat_marker = processed.join
        return repeat_marker, repeat_start
      else
        # Otherwise, remove the top of the list and start the set over
        processed.slice!(0)
        set = Set.new(processed)
      end

    end
  end
end
