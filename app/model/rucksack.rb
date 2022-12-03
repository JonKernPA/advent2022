class Rucksack

  GROUP_SIZE = 3

  attr_accessor :compartments, :repeated, :priority
  class << self
    attr_accessor :priority_sum, :groups, :group_count, :badge_sum
  end

  @priority_sum = nil
  @groups = [[]]
  @group_count = nil
  @badge_sum = nil

  def initialize(contents)
    Rucksack.priority_sum ||= 0
    Rucksack.group_count ||= 0
    # Rucksack.badge_sum ||= 0

    @compartments = []
    @compartments = contents.chars.each_slice( (contents.size/2).round ).to_a

    @repeated = (@compartments[0] & @compartments[1]).join('')

    @priority = Rucksack.prioritize(@repeated)
    Rucksack.priority_sum += @priority

    if Rucksack.groups.last.size < GROUP_SIZE
      Rucksack.groups.last << self
      Rucksack.group_count += 1
    else
      Rucksack.group_count = 0
      Rucksack.groups << [self]
    end
  end

  def to_s
    "%s %d" % [@repeated, @priority]
  end

  def self.prioritize(item)
    ranking = %w(- a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )
    index = ranking.index(item.strip)
    unless index
      puts "   !!! FAILED to rank '#{item}' --> #{index.inspect}"
    end
    index
  end

  def self.reset_priority_sum
    @priority_sum = 0
  end

  def self.process(file_name)
    # Rucksack.reset_priority_sum
    lines = 0
    File.readlines("#{file_name}").each do |contents|
      Rucksack.new(contents.strip)
      lines += 1
    end
    puts "#{lines} lines processed, #{Rucksack.groups.size} groups"
  end

  def self.reset_group
    @group_count = 0
  end

  def self.wipe_groups
    @groups = [[]]
  end

  def self.badge(group)
    if group.size == 3
      common_1 = group[0].compartments.flatten & group[1].compartments.flatten
      common_2 = group[1].compartments.flatten & group[2].compartments.flatten
      (common_1 & common_2).join('')
    else
      '-'
    end
  end

  def self.reset_badge_sum
    Rucksack.badge_sum = 0
  end

  def self.total_badges
    Rucksack.badge_sum = 0
    Rucksack.groups.each do |group|
      rucksack_badge = Rucksack.badge(group)
      Rucksack.badge_sum += Rucksack.prioritize(rucksack_badge)
    end
    Rucksack.badge_sum
  end

end
