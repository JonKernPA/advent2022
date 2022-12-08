$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'directory'

require 'spec_helper'

RSpec.describe 'DAY 7: Packrat Invaders', type: :model do

  describe 'Directory' do
    it '.name' do
      dir = Directory.new('a')
      expect(dir.name).to eql('a')
    end

    it 'can have a sub-directory' do
      top = Directory.new('/')
      sub_dir = Directory.new('a', top)
      expect(top.folders).to include(sub_dir)
    end

    it '.add_sub' do
      top = Directory.new('/')
      sub_dir = Directory.new('a')
      top.add_sub(sub_dir)
      expect(top.folders).to include(sub_dir)
    end

    it 'knows its parent' do
      dir = Directory.new('a')
      sub_dir = Directory.new('a')
      dir.add_sub(sub_dir)
      expect(sub_dir.parent).to eql(dir)
    end

    it 'knows its depth' do
      top = Directory.new('top')
      expect(top.depth).to eql(0)

      middle = Directory.new('middle', top)
      expect(middle.depth).to eql(1)

      lower = Directory.new('lower', middle)
      expect(lower.depth).to eql(2)
    end

    it 'has files' do
      dir = Directory.new('e')
      file = Xfile.new('i', 584)
      dir.add_file(file)
      expect(dir.files).to include(file)
    end

    it 'does not permit duplicates in same folder' do
      dir = Directory.new('e')
      file = Xfile.new('i', 584)
      dir.add_file(file)
      dir.add_file(file)
      expect(dir.files).to include(file)
      expect(dir.files.size).to eql(1)
    end

    context '.size' do
      it 'adds size of files in the current directory' do
        dir = Directory.new('e')
        file = Xfile.new('i', 584)
        dir.add_file(file)
        expect(dir.size).to eql(584)
      end

      it 'adds size of files in directory tree' do
        top = Directory.new('top')
        top.add_file(Xfile.new('i', 100))

        middle = Directory.new('middle', top)
        middle.add_file(Xfile.new('i', 200))

        lower = Directory.new('lower', middle)
        lower.add_file(Xfile.new('i', 300))

        expect(top.size).to eql(600)
      end

      it 'adds current and tree files' do
        da = Directory.new('a')
        da.add_file(Xfile.new('i', 100))

        de = Directory.new('e', da)
        de.add_file(Xfile.new('i', 584))

        da.add_file(Xfile.new('f', 29116))
        da.add_file(Xfile.new('g', 2557))
        da.add_file(Xfile.new('h', 62596))

        expect(da.size).to eql(100+584+29116+2557+62596)
      end
    end


    it 'finds dirs <= max' do
      top = Directory.new('top')
      a = Directory.new('a', top)
      e = Directory.new('e', a)
      e.add_file(Xfile.new('i', 584))
      a.add_file(Xfile.new('f', 29116))
      a.add_file(Xfile.new('g', 2557))
      a.add_file(Xfile.new('h', 62596))

      puts top

      expect(top.find_by_size(1000)).to eql([e])
      found = top.find_by_size(1000000)
      expect(found).to include(a, e)
      total = found.sum{|f| f.size}
      expect(total).to eql(95437)
      puts "Total: #{total}"
    end

    it 'finds folders smaller than a max' do
      top = Directory.new('top')
      top.add_file(Xfile.new('b.txt', 14848514))
      top.add_file(Xfile.new('c.dat', 8504156))

      a = Directory.new('a')
      top.add_sub(a)
      e = Directory.new('e')
      a.add_sub e
      e.add_file(Xfile.new('i', 584))

      a.add_file(Xfile.new('f', 29116))
      a.add_file(Xfile.new('g', 2557))
      a.add_file(Xfile.new('h', 62596))

      d = Directory.new('d')
      top.add_sub(d)
      d.add_file(Xfile.new('j', 4060174))
      d.add_file(Xfile.new('d.log', 8033020))
      d.add_file(Xfile.new('d.ext', 5626152))
      d.add_file(Xfile.new('k', 7214296))

      puts top

      expect(top.find_by_size(100000).sum{|f| f.size}).to eql(95437)

    end
  end

  describe 'Xfile' do

    it 'has a name' do
      file = Xfile.new('i')
      expect(file.name).to eql('i')
    end

    it 'has a default size of 0' do
      file = Xfile.new('i')
      expect(file.size).to eql(0)
    end

    it 'has a size' do
      file = Xfile.new('i', 584)
      expect(file.size).to eql(584)
    end
  end

  describe 'Drive commands' do

    it 'has a root directory structure' do
      drive = Drive.new
      expect(drive.root.name).to eql("/")
    end

    it 'has a rapid list of all folders' do
      drive = Drive.new
      expect(Drive.folders).to eql([drive.root])

      dir_a = drive.parse('dir a')
      dir_b = drive.parse('dir b')
      expect(Drive.folders).to include(drive.root, dir_a, dir_b)
    end

    it 'has a present working directory' do
      drive = Drive.new
      expect(drive.pwd.name).to eql("/")
    end

    describe  'processes commands' do
      it 'creates a directory' do
        drive = Drive.new
        dir_a = drive.parse('dir a')
        dir = drive.root
        expect(dir.folders).to include(dir_a)
      end

      it 'changes directory' do
        drive = Drive.new
        drive.parse('dir a')
        drive.parse('$ cd /')
        expect(drive.pwd.name).to eql('/')
        drive.parse('$ cd a')
        expect(drive.pwd.name).to eql('a')
      end

      it 'goes back one directory' do
        drive = Drive.new
        drive.parse('dir a')
        drive.parse('$ cd a')
        drive.parse('dir d')
        drive.parse('$ cd d')
        drive.parse('$ cd ..')
        expect(drive.pwd.name).to eql('a')
      end

      it 'creates files' do
        drive = Drive.new
        dir_a = drive.parse('dir a')
        dir_a = drive.parse('$ cd a')

        f = drive.parse('14848514 b.txt')
        expect(dir_a.files).to include(f)
        expect(f.size).to eql(14848514)

        z = drive.parse('252761 zlz')
        expect(dir_a.files).to include(z)
        expect(z.size).to eql(252761)
      end

    end


    it 'processes a test file' do
      drive = Drive.new
      puts drive.root.name
      drive.process('spec/test_input.txt')

      puts drive.root.to_tree
      puts drive
    end

    it 'processes contents from a test file' do
      drive = Drive.new
      puts drive.root.name
      drive.process('spec/test_input_day7.txt')

      found = drive.root.find_by_size(1000000)
      total = found.sum{|f| f.size}
      expect(total).to eql(95437)
      puts "Total for 100K or less directories: #{total}"

      puts drive.root
      puts drive.to_s
      expect(drive.used).to eql(48381165)
    end

  end

  describe 'Do the Full Problem' do

    it 'processes contents from the input file' do
      drive = Drive.new
      drive.process('app/data/day7.txt')

      expect(Drive.folders.select{|f| f.name == 'zlv'}).to be_truthy

      found = drive.root.find_by_size(1000000)
      total = found.sum{|f| f.size}
      puts "Total for 100K or less directories: #{total}"
      expect(total).to_not eql(34141481)

      expect(drive.used).to eql(42)
    end

  end

  context 'Part 2 - ' do

    # it 'processes contents from the input file' do
    #   receiver = Receiver.new('app/data/day7.txt')
    #   expect(receiver.message_marker).to eql('prhvlgftcbnwjq')
    #   expect(receiver.message_start).to eql(2851)
    # end

  end

end
