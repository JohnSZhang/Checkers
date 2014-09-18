class Board
  SIZE = 10

  attr_reader :grid

  def initialize
    make_grid
    #generate pieces
  end

  def make_grid
    @grid = Array.new(SIZE) { Array.new(SIZE) }
  end

  def make_pieces

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
    self.grid.each do |row|
      row.each do |cell|
        cell.is_a?(Piece) ? print(cell.render) : print("| |")
      end
      print "\n"
    end
  end

end