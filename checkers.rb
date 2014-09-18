require_relative "board"
require_relative "piece"
class Game

end


if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.render
  test = Piece.new(board, [4,4], :red)
  p test.slide_moves
  # p test.jump_moves
  opp = Piece.new(board, [5,5], :black)
  # p test.jump_moves
  # Jumping Apears to be working
  # board.render
  # test.move([6,6])
  # puts
  # board.render
  # test.move([7,7])
  board.render
  test.perform_moves!([[6,6],[7,7]])
  board.render
end