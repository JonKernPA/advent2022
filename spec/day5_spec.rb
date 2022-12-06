$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'cargo_hold'

require 'spec_helper'

RSpec.describe 'DAY 5: Rearrange Cargo', type: :model do

  describe 'Cargo' do
    it '.processes_cargo' do
      lines = %Q{    [D]
[N] [C]
[Z] [M] [P]
 1   2   3}
      cargo = Cargo.new(lines)
      expect(cargo.stacks.size).to eql(3)
      stacks = cargo.stacks

      expect(stacks[0].join).to eql('ZN')
      expect(stacks[1].join).to eql('MCD')
      expect(stacks[2].join).to eql('P')
    end

    it '.processes_cargo with a gap' do
      lines = %Q{[Z] [Q]         [Z] [W] [L] [J] [B]
[S] [W] [H]     [B] [H] [D] [C] [M]
[P] [R] [S] [G] [J] [J] [W] [Z] [V]
 1   2   3   4   5   6   7   8   9}
      cargo = Cargo.new(lines)
      expect(cargo.stacks.size).to eql(9)
      stacks = cargo.stacks

      expect(stacks[0].join).to eql('PSZ')
      expect(stacks[2].join).to eql('SH')
      expect(stacks[3].join).to eql('G')
      expect(stacks[4].join).to eql('JBZ')
      expect(stacks[8].join).to eql('VMB')
    end

    it 'can move crates' do
      lines = %Q{    [D]
[N] [C]
[Z] [M] [P]
 1   2   3}
      cargo = Cargo.new(lines)
      cargo.move(1, 2, 1)
      expect(cargo.stacks[0].join).to eql('ZND')
      expect(cargo.stacks[1].join).to eql('MC')
      expect(cargo.stacks[2].join).to eql('P')

      cargo.move(3, 1, 3)
      expect(cargo.stacks[0].join).to eql('')
      expect(cargo.stacks[1].join).to eql('MC')
      expect(cargo.stacks[2].join).to eql('PDNZ')

      cargo.move(2, 2, 1)
      expect(cargo.stacks[0].join).to eql('CM')
      expect(cargo.stacks[1].join).to eql('')
      expect(cargo.stacks[2].join).to eql('PDNZ')

      cargo.move(1, 1, 2)
      expect(cargo.stacks[0].join).to eql('C')
      expect(cargo.stacks[1].join).to eql('M')
      expect(cargo.stacks[2].join).to eql('PDNZ')

      expect(cargo.top_crates).to eql('CMZ')
    end

  end

  describe 'Cargo Hold Test' do
    it 'processes contents from a test file' do
      hold = CargoHold.new('spec/test_input_day5.txt')
      expect(hold.cargo.stacks.size).to eql(3)
      expect(hold.cargo.stacks[0].size).to eql(2)
      expect(hold.cargo.stacks[1].size).to eql(3)
      expect(hold.cargo.stacks[2].size).to eql(1)
    end

    it 'processes all moves' do
      hold = CargoHold.new('spec/test_input_day5.txt')
      hold.process_moves
      stacks = hold.cargo.stacks
      expect(stacks[0].join).to eql('C')
      expect(stacks[1].join).to eql('M')
      expect(stacks[2].join).to eql('PDNZ')

      expect(hold.cargo.top_crates).to eql('CMZ')
    end

  end

  describe 'Do the Full Problem' do
    it 'processes contents from the input file' do
      hold = CargoHold.new('app/data/day5.txt')
      hold.process_moves
      expect(hold.cargo.top_crates).to eql('ZWHVFWQWW')
    end
  end

  context 'Part 2 - multi-crate moves' do
    it 'can move multiple crates at a time' do
      lines = %Q{    [D]
[N] [C]
[Z] [M] [P]
 1   2   3}
      cargo = Cargo.new(lines)

      cargo.move_multiple(1, 2, 1)
      expect(cargo.stacks[0].join).to eql('ZND')
      expect(cargo.stacks[1].join).to eql('MC')
      expect(cargo.stacks[2].join).to eql('P')

      cargo.move_multiple(3, 1, 3)
      expect(cargo.stacks[0].join).to eql('')
      expect(cargo.stacks[1].join).to eql('MC')
      expect(cargo.stacks[2].join).to eql('PZND')

      cargo.move_multiple(2, 2, 1)
      expect(cargo.stacks[0].join).to eql('MC')
      expect(cargo.stacks[1].join).to eql('')
      expect(cargo.stacks[2].join).to eql('PZND')

      cargo.move_multiple(1, 1, 2)
      expect(cargo.stacks[0].join).to eql('M')
      expect(cargo.stacks[1].join).to eql('C')
      expect(cargo.stacks[2].join).to eql('PZND')

      expect(cargo.top_crates).to eql('MCD')
    end

    it 'processes contents from the input file' do
      hold = CargoHold.new('app/data/day5.txt')
      hold.process_multiple_moves
      expect(hold.cargo.top_crates).to eql('HZFZCCWWV')
    end

  end

end
