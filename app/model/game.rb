require 'io/console'


class Game

  def initialize(opponent_move, my_move)
    @moves = [opponent_move, my_move]
    @points = 0
    @result = 'DRAW'
    judge

    @@total_score += @points
    puts "#{@result}: #{@points}"
  end

  def judge
    @result = Game.winner(@moves[0], @moves[1])
    score
  end

  def score
    points_for_shape
    points_for_result
    @points
  end

  # points for shape: 1 for Rock, 2 for Paper, and 3 for Scissors
  def points_for_shape
    @points += case my_move
                 when 'Rock'
                   1
                 when 'Paper'
                   2
                 when 'Scissors'
                   3
                 else
                   0
               end
  end

  # points for result: 0 if you lost, 3 if the round was a draw, and 6 if you won
  def points_for_result
    @points += case result
                 when 'WIN'
                   6
                 when 'LOSE'
                   0
                 when 'DRAW'
                   3
                 else
                   0
               end
  end

  def my_move
    @moves[1]
  end

  def points
    @points
  end

  def result
    @result
  end

  def total_score
    @total_score
  end

  def moves
    @moves
  end

  def self.reset_total_score
    @@total_score = 0
  end

  def self.convert(code)
    case code
      when 'A'
        'Rock'
      when 'B'
        'Paper'
      when 'C'
        'Scissors'
      when 'X'
        'Rock'
      when 'Y'
        'Paper'
      when 'Z'
        'Scissors'
    end
  end

  def self.interpret(code)
    case code
      when 'X'
        'LOSE'
      when 'Y'
        'DRAW'
      when 'Z'
        'WIN'
    end
  end

  def self.ensure_outcome(opponent, status)
    if status == 'DRAW'
      return opponent
    elsif status == 'LOSE'
      case opponent
        when 'Rock'
          'Scissors'
        when 'Paper'
          'Rock'
        when 'Scissors'
          'Paper'
      end
    elsif status == 'WIN'
      case opponent
        when 'Rock'
          'Paper'
        when 'Paper'
          'Scissors'
        when 'Scissors'
          'Rock'
      end
    else

    end
  end

  # Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock.
  def self.winner(opponent_move, my_move)
    if opponent_move == my_move
      win_state = 'DRAW'
    else
      win_state = case my_move
                    when 'Rock'
                      if opponent_move == 'Scissors'
                        'WIN'
                      elsif opponent_move == 'Paper'
                        'LOSE'
                      end
                    when 'Paper'
                      if opponent_move == 'Rock'
                        'WIN'
                      elsif opponent_move == 'Scissors'
                        'LOSE'
                      end
                    when 'Scissors'
                      if opponent_move == 'Paper'
                        'WIN'
                      elsif opponent_move == 'Rock'
                        'LOSE'
                      end
                    else
                      # type code here
                  end

    end
    win_state
  end

  def self.play_from_file(file_name)
    Game.reset_total_score
    total_score = 0
    File.readlines("#{file_name}").each do |round|
      opponent = Game.convert(round.split[0])
      me = Game.convert(round.split[1])
      game = Game.new(opponent, me)
      total_score += game.points
    end
    total_score
  end

  # Expect array
  def self.play(input)
    return -1 unless input.is_a?(Array)
    Game.reset_total_score
    total_score = 0
    input.each do |round|
      opponent = Game.convert(round.split[0])
      me = Game.convert(round.split[1])

      game = Game.new(opponent, me)
      total_score += game.points
    end
    total_score
  end

  def self.play_ensuring_outcome(file_name)
    Game.reset_total_score
    total_score = 0
    File.readlines("#{file_name}").each do |round|
      opponent = Game.convert(round.split[0])
      desired_status = Game.interpret(round.split[1])
      me = Game.ensure_outcome(opponent, desired_status)
      game = Game.new(opponent, me)
      total_score += game.points
    end
    total_score
  end


end
