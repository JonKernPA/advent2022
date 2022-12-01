$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'awesome_print'
require 'rubygems'
require 'elf'

require 'spec_helper'


RSpec.describe Elf, type: :model do

  it 'ingests input data' do
    input = [
      [1, 2, 3, 4, 5],
      [2],
    ]

    Elf.ingest(input)
    expect(Elf.clan.size).to eq(2)
  end

  it '#calories' do
    elf = Elf.new([0, 1, 2, 3, 4])
    expect(elf.calories).to eql(10)
  end

  it '#most_calories' do
    elf_1 = Elf.new([0, 1, 2, 3])
    elf_2 = Elf.new([10])
    elf_3 = Elf.new([1,1,2,2,3,1,1,5])
    expect(Elf.most_calories).to eql(elf_3)
  end

  it 'day1' do
    Elf.day_1
  end

end

