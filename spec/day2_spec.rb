$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/data")
require 'awesome_print'
require 'rubygems'
require 'game'

require 'spec_helper'


RSpec.describe 'DAY 2: Rock Paper Scissors Game', type: :model do

  describe '#initialize' do
    let(:game) {Game.new('Rock', 'Paper')}

    it 'has 2 moves' do
      expect(game.moves).to eql ['Rock', 'Paper']
    end

    it 'has my move' do
      expect(game.my_move).to eql 'Paper'
    end

    it 'judges the round' do
      expect(game.result).to eql('WIN')
    end

    it 'scores the round' do
      game = Game.new('Rock', 'Paper')
      expect(game.points).to eql(2+6)
    end
  end

  it 'chooses a winner' do
    expect(Game.winner('Rock', 'Paper')).to eql('WIN')
    expect(Game.winner('Rock', 'Scissors')).to eql('LOSE')
    expect(Game.winner('Rock', 'Rock')).to eql('DRAW')
  end

  it 'converts strategy codes' do
    expect(Game.convert('A')).to eql('Rock')
    expect(Game.convert('B')).to eql('Paper')
    expect(Game.convert('C')).to eql('Scissors')

    expect(Game.convert('X')).to eql('Rock')
    expect(Game.convert('Y')).to eql('Paper')
    expect(Game.convert('Z')).to eql('Scissors')
  end

  it 'play multiple rounds' do
    input = ['A Y', 'B X', 'C Z']
    total_score = Game.play(input)
    expect(total_score).to eql(15)
  end

  it 'play from a strategy guide file' do
    total_score = Game.play_from_file('spec/test_input_day2.txt')
    expect(total_score).to eql(15)
  end

  it 'does day 2 exercise' do
    total_score = Game.play_from_file('/Users/jon/railsprojects/advent_of_code_2022/advent2022/app/data/day2.txt')
    ap total_score
  end

  it 'interprets desired ending' do
    expect(Game.interpret('X')).to eql('LOSE')
    expect(Game.interpret('Y')).to eql('DRAW')
    expect(Game.interpret('Z')).to eql('WIN')
  end

  it 'ensures an outcome' do
    expect(Game.ensure_outcome('Rock', 'DRAW')).to eql('Rock')
    expect(Game.ensure_outcome('Paper', 'DRAW')).to eql('Paper')
    expect(Game.ensure_outcome('Scissors', 'DRAW')).to eql('Scissors')

    expect(Game.ensure_outcome('Rock', 'LOSE')).to eql('Scissors')
    expect(Game.ensure_outcome('Paper', 'LOSE')).to eql('Rock')
    expect(Game.ensure_outcome('Scissors', 'LOSE')).to eql('Paper')

    expect(Game.ensure_outcome('Rock', 'WIN')).to eql('Paper')
    expect(Game.ensure_outcome('Paper', 'WIN')).to eql('Scissors')
    expect(Game.ensure_outcome('Scissors', 'WIN')).to eql('Rock')
  end

  it 'does day 2 exercise Part 2' do
    total_score = Game.play_ensuring_outcome('/Users/jon/railsprojects/advent_of_code_2022/advent2022/app/data/day2.txt')
    ap total_score
  end

end
