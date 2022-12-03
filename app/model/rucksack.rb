class Rucksack

  attr_accessor :compartments, :repeated, :priority
  class << self
    attr_accessor :priority_sum
  end

  @priority_sum = nil

  def initialize(contents)
    Rucksack.priority_sum ||= 0

    @compartments = []
    @compartments = contents.chars.each_slice( (contents.size/2).round ).to_a
    # puts @compartments[0].join('')
    # puts @compartments[1].join('')
    @repeated = (@compartments[0] & @compartments[1]).join('')
    @priority = prioritize(@repeated)
    # puts "#{@repeated} - #{@priority}"
    Rucksack.priority_sum += @priority
    # puts "Sum: #{Rucksack.priority_sum}"
  end

  def prioritize(item)
    ranking = %w(- a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )
    index = ranking.index(item)
    unless index
      puts "!!! Ranking #{item} --> #{index.inspect}"
    end
    index
  end

  def self.reset_priority_sum
    @priority_sum = 0
  end

  def self.process(file_name)
    # Rucksack.reset_priority_sum
    File.readlines("#{file_name}").each do |contents|
      Rucksack.new(contents)
    end
  end

end
