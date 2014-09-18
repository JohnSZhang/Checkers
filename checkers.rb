require_relative "board"
require_relative "piece"
require_relative "render"

class Game
  COLORS = [:white, :red]
  HOUSES = {white: :York, red: :Lancaster}


  def initialize
    @board = Board.new
  end

  def test_mode
    @board = Board.new(true)
    Piece.new(board, [2,5], :white)
    Piece.new(board, [1,4], :red)
    Piece.new(board, [1,2], :red)
    board.render
    @board[[2,5]].perform_moves([[0,3],[2,1]])
    board.render
  end

  def play
    title_screen
    current_player = :white
    until self.board.over?
      wipe
      begin
        self.take_turn(current_player)
      rescue StandardError => e
        puts e.message
        retry
      end
      current_player = self.opponent(current_player)
    end
    wipe
    board.render
    puts "game is over, house #{HOUSES[opponent(current_player)]} won"
    sleep(4)
  end

  protected

  attr_reader :board

  def opponent(player)
    COLORS[(COLORS.index(player) + 1) % 2]
  end

  def take_turn(player)

    self.board.render
    puts "It's House #{HOUSES[player]}'s turn, please pick a piece"

    selected_piece = self.board[self.get_piece]
    unless !selected_piece.nil? && selected_piece.color == player
      puts "That's not one of your pieces! #{HOUSES[player]}, let's try again"
      selected_piece = self.board[self.get_piece]
    end

    puts "Please enter where you want to move to"
    selected_piece.perform_moves(get_moves)
  end


  def get_moves
    moves = gets.chomp.split(' ')
    moves.map do |move|
      split_single_move(move)
    end

  end

  def split_single_move(move)
    move = move.split(',')
    x, y = move
    raise "Not valid position" unless Integer(x) || Interger(y)
    move.map{|i| i.to_i}
  end

  def title_screen
    wipe
    text = "War".red.blink + " of the " + "Roses".white.blink
    print text
    sleep(3)
  end


  def get_piece
    begin
      pos = gets.chomp
      pos = pos.split(',')
      x, y = pos
      raise "Not valid position" unless Integer(x) || Interger(y)
      pos = [x.to_i, y.to_i]
    rescue => e
      puts e
      retry
    end
    pos
  end

end

if __FILE__ == $PROGRAM_NAME

  #TEST A GAME
  game = Game.new
  game.play

  # board = Board.new(true)
  # piece1 = Piece.new(board, [2,2], :red)
  # piece2 = Piece.new(board, [3,3], :black)
  # piece3 = Piece.new(board, [5,5], :black)
  # piece4 = Piece.new(board, [7,5], :black)
  # p board.pieces.count
  # piece1.perform_moves([[4,4],[6,6],[8,4]])
  # board.render
  # p board.over?

  #FOR TESTING FULL GAMES
  # board.render
  #
  # # INITIALIZE MORE RANDOMIZED BOARD POSITION FOR TESTING
  # board[[3,0]].move([4,1])
  # board[[4,1]].move([5,2])
  # board[[6,5]].move([5,4])
  # board[[7,6]].move([6,5])
  # board[[7,2]]= nil
  # board[[9,0]]= nil
  # board[[7,0]]= nil
  # board[[9,2]]= nil
  # board[[6,5]]= nil
  # board[[7,4]]= nil
  # board[[8,5]]= nil
  # board[[5,2]].perform_moves!([[7,0],[9,2]])
  # board.render

  #Checking Dupped
  # dup = board.dup
  # p dup.render
  # dup[[5,2]].perform_moves!([[7,0],[9,2]])
  # dup.render
  # board.render

  #Checking If Valid_move_seq works
  # p board[[5,2]].perform_moves!([[7,0],[9,2]])
  # board.render

  #Check if Perform_moves is working as intended
  # p board[[5,2]].perform_moves!([[7,0],[9,2]])
  # board.render

  #Sliding Twice
  # board[[3,2]].perform_moves!([[4,1],[5,0]])

  #Slide Then Jump
  # board[[3,4]].perform_moves!([[4,3],[6,5]])

  # #Jump Then Slide
  # board[[5,2]].perform_moves!([[7,4],[8,5]])

  #Double Jump And Upgrade
  # board[[5,2]].perform_moves!([[7,0],[9,2]])
  # board.render

end