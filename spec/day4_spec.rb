$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'assignment'

require 'spec_helper'

RSpec.describe 'DAY 4: Cleaning Assignments', type: :model do

  describe 'Pair' do
    it 'has a range of sections' do
      pair = Pair.new('2-4')
      expect(pair.sections).to eql([2,3,4])
    end

  end

  describe 'Assignment' do
    it 'has a pair of assignments' do
      assignment = Assignment.new('2-4,6-8')
      expect(assignment.pair[0].sections).to eql([2,3,4])
      expect(assignment.pair[1].sections).to eql([6,7,8])
    end

    it 'can detect overlaps' do
      assignment = Assignment.new('2-4,6-8')
      expect(assignment.overlap).to be_falsey

      assignment = Assignment.new('2-3,4-5')
      expect(assignment.overlap).to be_falsey

      assignment = Assignment.new('5-7,7-9')
      expect(assignment.overlap).to be_falsey

      assignment = Assignment.new('2-8,3-7')
      expect(assignment.overlap).to be_truthy

      assignment = Assignment.new('3-7,2-8')
      expect(assignment.overlap).to be_truthy

      assignment = Assignment.new('6-6,4-6')
      expect(assignment.overlap).to be_truthy
    end
  end

  describe 'Assignment Maker' do
    it 'processes contents from a file' do
      maker = AssignmentMaker.new('spec/test_input_day4.txt')
      expect(maker.overlap_count).to eql(2)
    end
  end

  describe 'Do the Full Problem' do
    it 'processes contents from a file' do
      maker = AssignmentMaker.new('app/data/day4.txt')
      ap "TADA: #{maker.overlap_count}"
      expect(maker.overlap_count).to eql(448)
    end
  end


end
