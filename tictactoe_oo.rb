# what is a TicTacToe game? and how it works?

# TicTacToe game is a simple board game that is played between 2 players.
# It has 3x3 squares on the board. Each player choose between 'X' marker or 'O' marker.
# Player takes turn to put their marker on the board until player gets 3 own marker in a row or squares on the board is empty

class Board
  WINNING_POSITIONS = [ [1,2,3], [4,5,6], [7,8,9],
                        [1,4,7], [2,5,8], [3,6,9],
                        [1,5,9], [3,5,7] ]

  attr_accessor :data

  def initialize
    @data = {}
    (1..9).each { |position| data[position] = ' ' }
  end

  def draw
    system 'clear'
    puts "     |     |     "
    puts "  #{data[1]}  |  #{data[2]}  |  #{data[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{data[4]}  |  #{data[5]}  |  #{data[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{data[7]}  |  #{data[8]}  |  #{data[9]}  "
    puts "     |     |     "
  end

  def empty_square
    data.select { |_, value| value == ' ' }.keys
  end

  def no_empty_square?
    if data.select { |_, value| value == ' ' }.keys.empty?
      puts "It's a tie!"
      exit
    end
  end

  def mark(player)
    begin
      puts "#{player.name}: Choose a position (from 1 to 9) to place a piece"
      position = gets.chomp.to_i
    end until empty_square.include?(position)

    data[position] = player.marker
  end

  def mark_auto(player, another_player)
    puts "#{player.name} chooses a square..."
    sleep 0.5

    calculate_moves_auto(player.marker, another_player.marker)
  end

  def check_winner(player)
    WINNING_POSITIONS.each do |line|
      return display_winning_message(player.name) if data.values_at(*line).count(player.marker) == 3
    end
    nil
  end

  def display_winning_message(player_name)
    puts "#{player_name} have won!"
    exit
  end

  def two_in_a_row(hash, pick)
    if hash.values.count(pick) == 2
      hash.select { |_, v| v == ' '}.keys.first
    else
      false
    end
  end

  def calculate_moves_auto(marker, other_marker)
    defend_square = nil
    attacked = false

    WINNING_POSITIONS.each do |line|
      defend_square = two_in_a_row({ line[0] => data[line[0]],
                                       line[1] => data[line[1]],
                                       line[2] => data[line[2]]}, marker)

      if defend_square
        data[defend_square] = marker
        attacked = true
        break
      end
    end

    if attacked == false
      WINNING_POSITIONS.each do |line|
        defend_square = two_in_a_row({ line[0] => data[line[0]],
                                         line[1] => data[line[1]],
                                         line[2] => data[line[2]]}, other_marker)

        if defend_square
          data[defend_square] = marker
          break
        end
      end
    end

    data[empty_square.sample] = marker unless defend_square
  end
end

class Player
  attr_accessor :marker
  attr_reader :name

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    @board = Board.new
    @player = Player.new('Jack', 'X')
    @computer = Player.new('R2D2', 'O')
  end

  def play
    @board.draw

    loop do
      @board.mark(@player)
      @board.draw
      break if @board.check_winner(@player) || @board.no_empty_square?
      @board.mark_auto(@computer, @player)
      @board.draw
      break if @board.check_winner(@computer) || @board.no_empty_square?
    end
  end
end

Game.new.play
