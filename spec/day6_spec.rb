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
      expect(receiver.packet_marker).to eql('jpqm')
      expect(receiver.packet_start).to eql(7)
    end

    describe '.find_packet_marker' do
      it 'processes a string using default of 4 characters' do
        receiver = Receiver.new('spec/test_input_day6.txt')

        expect(receiver.find_packet_marker('bvwbjplbgvbhsrlpgdmjqwftvncz')).to eql(['vwbj', 5])
        expect(receiver.find_packet_marker('nppdvjthqldpwncqszvftbrmjlhg')).to eql(['pdvj', 6])
        expect(receiver.find_packet_marker('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg')).to eql(['rfnt', 10])
        expect(receiver.find_packet_marker('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw')).to eql(['zqfr', 11])

      end

    end

  end

  describe 'Do the Full Problem' do

    it 'processes contents from the input file' do
      receiver = Receiver.new('app/data/day6.txt')
      expect(receiver.packet_marker).to eql('jqvg')
      expect(receiver.packet_start).to eql(1794)
    end
  end

  context 'Part 2 - ' do

    it 'processes a string using 14 characters' do
      receiver = Receiver.new('spec/test_input_day6.txt')

      expect(receiver.find_message_start('mjqjpqmgbljsphdztnvjfqwrcgsmlb')).to eql(['qmgbljsphdztnv', 19])
      expect(receiver.find_message_start('bvwbjplbgvbhsrlpgdmjqwftvncz')).to eql(['vbhsrlpgdmjqwf', 23])
      expect(receiver.find_message_start('nppdvjthqldpwncqszvftbrmjlhg')).to eql(['ldpwncqszvftbr', 23])
      expect(receiver.find_message_start('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg')).to eql(['wmzdfjlvtqnbhc', 29])
      expect(receiver.find_message_start('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw')).to eql(['jwzlrfnpqdbhtm', 26])

    end

    it 'processes contents from the input file' do
      receiver = Receiver.new('app/data/day6.txt')
      expect(receiver.message_marker).to eql('prhvlgftcbnwjq')
      expect(receiver.message_start).to eql(2851)
    end


  end

end
