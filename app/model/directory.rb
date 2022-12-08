

class Directory
  attr_accessor :name, :folders, :files, :parent, :depth

  def initialize(name, parent=nil)
    @name = name
    @folders = []
    @files = []
    @size = 0
    @parent = nil
    @depth = 0
    if parent
      parent.add_sub(self)
    end
  end

  def add_sub(dir)
    @folders << dir
    dir.parent = self
    dir.depth = self.depth + 1
  end

  def add_file(file)
    @files << file unless @files.include?(file)
    file
  end

  def size
    @size = 0
    @files.each do |f|
      @size += f.size
    end
    @folders.each {|f| @size += f.size}
    @size
  end

  def find_by_size(max_size)
    found = []
    @folders.each do |f|
      if f.size <= max_size
        found << f
        # puts "%5s %d" % [f.name, f.size]
      end
      if f.folders.any?
        found += f.find_by_size(max_size)
      end
    end
    found.flatten
  end

  def to_tree
    to_s(false)
  end

  def to_s(show_files=true)
    text = []
    line = '  ' * @depth
    line += "- #{name}#{show_files ? '' : ' (dir)'}"
    text << line
    print_folders(text)
    print_files(text) if show_files
    text.join("\n")
  end

  private

  def print_folders(text)
    @folders.each do |dir|
      text << dir.to_s
    end
  end

  def print_files(text)
    @files.each do |file|
      line = '  ' * (@depth + 1)
      line += "- #{file.name} (file, size=#{file.size})"
      text << line
    end
  end

end

class Xfile
  attr_accessor :name, :size

  def initialize(name, size=0)
    @name = name
    @size = size.to_i
  end

  def to_s
    "#{name}, #{size}"
  end
end

class Drive

  class << self
    attr_accessor :folders
  end

  @folders = []

  attr_accessor :used, :root, :pwd

  def initialize
    Drive.folders = []
    @used = 0
    @root = create_directory('/')
    @pwd = @root
  end

  def create_directory(name, parent=nil)
    # puts ">> Creating #{name} under #{parent&.name}"
    dir = Directory.new(name, parent)
    Drive.folders << dir
    dir
  end

  def parse(command)
    debug = false
    case command
      when /\$ cd \.\./
        puts "up one dir level to #{@pwd&.parent&.name}" if debug
        @pwd = @pwd.parent if @pwd.parent
      when /\$ cd (\S+)/
        puts "change dir to #{$1}" if debug
        Drive.folders.each {|f| f.name}
        dir = Drive.folders.select{|f| f.name == $1 }
        @pwd = dir.first if dir.any?
      when /\$ ls/
        puts "list dir" if debug
        puts @pwd
      when /dir (\S+)/
        create_directory($1, @pwd)
      when /^(\d+) (.*)$/
        puts "create file: #{$2}, #{$1}" if debug
        file = @pwd.add_file(Xfile.new($2, $1))
        @used += file.size
        file
      else
        puts "Unknown? #{command}"
    end

  end

  def process(file_name)
    lines = 0
    @used = 0
    File.readlines("#{file_name}").each do |command|
      parse(command)
      lines += 1
    end
    puts "#{lines} lines processed"
    puts self.to_s
  end

  def to_s
    text = ['-'*25]
    text << "Total Folders: #{Drive.folders.size}"
    text << "Total Disk Space Used: #{used}"
    text << ['-'*25]
    text.join("\n")
  end

end
