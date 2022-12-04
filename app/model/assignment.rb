class Pair
  attr_accessor :sections

  def initialize(range)
    @sections = []
    start_section,end_section = range.split('-')
    @sections = (start_section.to_i..end_section.to_i).map {|s| s}
  end
end



class Assignment

  attr_accessor :pair

  def initialize(assignment_pair)
    @pair = []
    assignment_pair.split(',').each do |a|
      @pair << Pair.new(a)
    end
  end

  # This requires one array to be FULLY in the other array
  def overlap
    results = (@pair[0].sections & pair[1].sections) || (@pair[1] & pair[0])
    results.any? && (results == @pair[0].sections || results == @pair[1].sections)
  end

end

class AssignmentMaker

  attr_accessor :overlap_count

  def initialize(file_name)
    lines = 0
    @overlap_count = 0
    File.readlines("#{file_name}").each do |contents|
      assignment = Assignment.new(contents)
      @overlap_count += 1 if assignment.overlap
      lines += 1
    end
    puts "#{lines} lines processed, #{@overlap_count} overlaps"
  end

end
