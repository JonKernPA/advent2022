$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'receiver'

require 'spec_helper'

RSpec.describe 'DAY 6: Communication Protocol', type: :model do


  describe 'Receiver Test' do
    it 'processes contents from a test file' do
      receiver = Receiver.new('spec/test_input_day6.txt')
      expect(receiver.packet_marker).to eql(['jpqm', 7])
    end

    describe '.find_marker' do
      it 'processes a string' do
        receiver = Receiver.new('spec/test_input_day6.txt')
        expect(receiver.find_repeater('bvwbjplbgvbhsrlpgdmjqwftvncz')).to eql(['vwbj', 5])
        expect(receiver.find_repeater('nppdvjthqldpwncqszvftbrmjlhg')).to eql(['pdvj', 6])
        expect(receiver.find_repeater('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg')).to eql(['rfnt', 10])
        expect(receiver.find_repeater('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw')).to eql(['zqfr', 11])

      end
    end

  end

  describe 'Do the Full Problem' do

    it 'processes contents from the input file' do
      receiver = Receiver.new('app/data/day6.txt')
      expect(receiver.packet_marker).to eql(['jqvg', 1794])
    end
  end

  context 'Part 2 - ' do

    # it 'processes contents from the input file' do
    #   hold = CargoHold.new('app/data/day6.txt')
    #   hold.process_multiple_moves
    #   expect(hold.cargo.top_crates).to eql('HZFZCCWWV')
    # end

  end

end
