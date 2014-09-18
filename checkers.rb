require_relative "board"
require_relative "piece"
class Game
  COLORS = [:black, :red]
  attr_reader :board

  def initialize

    @board = Board.new
  end

  def game
    until self.board.over?
      begin
      rescue
        self.get_turn(player)
        retry
      end
      current_player = other_player
    end

    puts "game is over, player X won"
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new(true)
  piece1 = Piece.new(board, [2,2], :red)
  piece2 = Piece.new(board, [3,3], :black)
  piece3 = Piece.new(board, [5,5], :black)
  piece4 = Piece.new(board, [7,5], :black)
  piece1.perform_moves([[4,4],[6,6],[8,4]])
  board.render

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