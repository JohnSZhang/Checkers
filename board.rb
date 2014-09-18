require_relative "piece"
class Board
  SIZE = 10

  attr_reader :grid

  def initialize(blank = false)
    make_grid
    make_pieces unless blank == true
  end

  def make_grid
    @grid = Array.new(SIZE) { Array.new(SIZE) }
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

  def make_pieces
    colors = {black: [6, 7, 8, 9],
      red: [0, 1, 2, 3] }

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

  def render
    print "| ||"
    print (0..9).to_a.join("||")
    print "|\n"
    self.grid.each_with_index do |row, index|
      print "|#{index}|"
      row.each do |cell|
        cell.is_a?(Piece) ? print(cell.render) : print("| |")
      end
      print "\n"
    end
  end

end