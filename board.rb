require_relative "piece"
class Board
  BACKGROUND = {1 => :light_black,
                0 => :light_white}
  SIZE = 10

  attr_reader :grid

  def initialize(blank = false)
    make_grid
    make_pieces unless blank == true
  end

  def dup
    new_board = self.class.new(true)
    self.grid.each do |row|
      row.each do |tile|
        Piece.new(new_board, tile.pos, tile.color) unless tile.nil?
      end
    end
    new_board
  end

  def []= (pos, value)
    x, y = pos
    self.grid[x][y] = value
  end

  def [](pos)
    self.grid[pos.first][pos.last]
  end

  def on_board?(pos)
    pos.all?{|i| (0...SIZE).include?(i)}
  end

  def over?
    self.no_piece?(:red) || self.no_piece?(:white)
  end

  def render
    wipe
    print "| ||"
    print (0..9).to_a.join("||")
    print "|\n"
    self.grid.each_with_index do |row, i|
      print "|#{i}|"
      row.each_with_index do |cell, j|
        self.render_tile(cell, i, j)
      end
      print "\n"
    end
  end

  protected

  def make_grid
    @grid = Array.new(SIZE) { Array.new(SIZE) }
  end

  def make_pieces
    colors = {white: [6, 7, 8, 9], red: [0, 1, 2, 3] }

    SIZE.times do |i|
      SIZE.times do |j|
        unless [4, 5].include?(i)
          color = colors.select{|k, v| v.include?(i)}.first
          # If only one of the row, col index is odd
          if [i,j].select{ |v| v % 2 != 0 }.count == 1
            Piece.new(self, [i,j], color.first)
          end
        end
      end
    end

  end

  def pieces
    self.grid.flatten.compact
  end

  def no_piece?(color)
    self.pieces.none?{|piece| piece.color == color }
  end

  def render_tile(piece, i, j)
    string = (piece.is_a?(Piece) ? piece.render : "| |")
    bg_v = [i,j].inject(0){ |acc, v| acc + (v % 2) }
    bg = (bg_v == 1 ? BACKGROUND[1] : BACKGROUND[0])
    string = string.colorize(:background => bg)
    print string
  end

end