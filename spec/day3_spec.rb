$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'rucksack'

require 'spec_helper'

RSpec.describe 'DAY 3: Rucksack Contents', type: :model do

  it 'has contents in 2 compartments' do
    rucksack = Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    expect(rucksack.compartments.size).to eql(2)
    expect(rucksack.compartments[0].join('')).to eql('vJrwpWtwJgWr')
    expect(rucksack.compartments[1].join('')).to eql('hcsFMMfFFhFp')
  end

  it 'finds matching contents in each compartment' do
    rucksack = Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    expect(rucksack.repeated).to eql('p')
  end

  it 'can prioritize contents' do
    rucksack = Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    expect(rucksack.priority).to eql(16)
  end

  it 'can reset priority_sum' do
    Rucksack.reset_priority_sum
    expect(Rucksack.priority_sum).to eql(0)
  end

  it 'accumulates priorities' do
    Rucksack.reset_priority_sum
    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    Rucksack.new('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
    Rucksack.new('PmmdzqPrVvPwwTWBwg')
    Rucksack.new('wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn')
    Rucksack.new('ttgJtRGJQctTZtZT')
    Rucksack.new('CrZsJsPPZsGzwwsLwLmpwMDw')

    expect(Rucksack.priority_sum).to eql(157)
  end

  it 'processes contents from a file' do
    Rucksack.reset_priority_sum
    Rucksack.process('spec/test_input_day3.txt')
    expect(Rucksack.priority_sum).to eql(157)
  end

  it 'does the day 3 exercise' do
    Rucksack.reset_priority_sum
    Rucksack.process('app/data/day3.txt')
    ap Rucksack.priority_sum
  end
end
