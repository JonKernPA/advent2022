$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'rucksack'

require 'spec_helper'

RSpec.describe 'DAY 3: Rucksack Contents', type: :model do

  before :each do
    Rucksack.wipe_groups
    Rucksack.reset_priority_sum

  end

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
    expect(Rucksack.priority_sum).to eql(0)
  end

  it 'accumulates priorities' do
    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    Rucksack.new('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
    Rucksack.new('PmmdzqPrVvPwwTWBwg')
    Rucksack.new('wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn')
    Rucksack.new('ttgJtRGJQctTZtZT')
    Rucksack.new('CrZsJsPPZsGzwwsLwLmpwMDw')

    expect(Rucksack.priority_sum).to eql(157)
  end

  it 'processes contents from a file' do
    Rucksack.process('spec/test_input_day3.txt')
    expect(Rucksack.priority_sum).to eql(157)
  end

  it 'does the day 3 exercise' do
    Rucksack.process('app/data/day3.txt')
    ap Rucksack.priority_sum
  end

  it 'defines group as cluster of 3' do
    expect(Rucksack::GROUP_SIZE).to eql(3)
  end

  it 'resets the group counter' do
    Rucksack.reset_group
    expect(Rucksack.group_count).to eql(0)
  end

  it 'increments group count on object creation' do
    Rucksack.reset_group
    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    expect(Rucksack.group_count).to eql(1)
  end

  it 'has groups of elves' do
    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    Rucksack.new('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
    Rucksack.new('PmmdzqPrVvPwwTWBwg')

    Rucksack.new('wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn')
    Rucksack.new('ttgJtRGJQctTZtZT')
    Rucksack.new('CrZsJsPPZsGzwwsLwLmpwMDw')

    Rucksack.new('GGVGlqWFgVfFqqVZGFlblJPMsDbbMrDMpDsJRn')
    Rucksack.new('LwzHtwdLHHwDrzPZzzsJbJ')
    Rucksack.new('wdLTBvSvHvZVGCjhfN')

    expect(Rucksack.groups.size).to eql(3)
  end

  it 'detects group badge' do
    Rucksack.wipe_groups

    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    Rucksack.new('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
    Rucksack.new('PmmdzqPrVvPwwTWBwg')

    expect(Rucksack.badge(Rucksack.groups[0])).to eql('r')
  end

  it 'detects badges for multiple groups and sums the priority' do
    # Rucksack.reset_badge_sum

    Rucksack.new('vJrwpWtwJgWrhcsFMMfFFhFp')
    Rucksack.new('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
    Rucksack.new('PmmdzqPrVvPwwTWBwg')

    Rucksack.new('wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn')
    Rucksack.new('ttgJtRGJQctTZtZT')
    Rucksack.new('CrZsJsPPZsGzwwsLwLmpwMDw')

    Rucksack.total_badges
    expect(Rucksack.badge_sum).to eql(70)
  end

  it 'does the day 3 exercise test' do
    Rucksack.process('spec/test_input_day3.txt')
    expect(Rucksack.groups.size).to eql(2)
    ap Rucksack.total_badges
  end

  it 'does the day 3 exercise, part 2' do
    Rucksack.process('app/data/day3.txt')

    total = Rucksack.total_badges
    puts "Total Badges: #{total}"
    expect(total).to eql(2821)
  end

end
