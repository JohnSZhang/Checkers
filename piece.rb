require_relative "errors"
require "colorize"
class Piece
  OPP_COLOR = { black: :red,
    red: :black }

  BACK_ROW = { black: 0,
    red: 9 }

  MOVES = { black: [ [-1, 1], [-1, -1]],
    red: [ [1, -1], [1, 1] ]}

  attr_accessor :pos, :color, :upgrade

  attr_reader :board, :back_row

  def initialize(board, pos, color, upgrade = false)
    @board = board
    board[pos] = self
    self.pos = pos
    self.color = color
    self.upgrade = upgrade
    @back_row = BACK_ROW[color]
  end

  def slide_moves
    x, y = self.pos

    MOVES[self.color].each_with_object([]) do |pos, moves|
      new_pos = [x + pos.first, y + pos.last]
      next false unless self.board.on_board?(new_pos)
        moves << [new_pos, []] if self.board[new_pos].nil?
    end

  end

  def jump_moves
    x, y = self.pos

    MOVES[self.color].each_with_object([]) do |pos, moves|

      enemy_pos =[ x + pos.first, y + pos.last ]
      new_pos =[ x + pos.first * 2 , y + pos.last * 2 ]

      next false unless self.board.on_board?(new_pos)
      next false unless self.board[enemy_pos].is_a?(Piece)

      if self.board[new_pos].nil? && self.board[enemy_pos].color != self.color
        moves << [new_pos, enemy_pos]
      end

    end
  end

  def move(pos)
    possible_moves = self.slide_moves + self.jump_moves
    p possible_moves
    raise InvalidMoveError unless possible_moves.map(&:first).include?(pos)

    move = possible_moves.select{ |el| el.first == pos }.flatten(1)
    self.new_pos(move.first)
    self.killer_move(move.last) unless move.last.empty?
    self.upgrade = true if self.pos.first == back_row
  end

  def is_slide?(pos)
    self.slide_moves.map(&:first).include?(pos)
  end

  def is_jump?(pos)
    self.jump_moves.map(&:first).include?(pos)
  end

  def perform_moves!(seq)
    slided = false
    jumped = false

    seq.each do |single_move|
      #Would be easier to break from loop but this is more explicit
      #jumping and slided
      raise SlideAfterJumpError if jumped && is_slide?(single_move)
      #slid after jumping
      raise JumpingAfterSlideError if slided && is_jump?(single_move)
      # multiple slides
      raise SlideAfterSlideError if slided && is_slide?(single_move)
      slided = true if self.is_slide?(single_move)
      jumped = true if self.is_jump?(single_move)
      self.move(single_move)
    end
  end

  def valid_move_seq?(seq)
    dupped = self.board.dup
    begin
      dupped[self.pos].perform_moves!(seq)
    rescue
      return false
    else
      true
    end
  end

  def perform_moves(seq)
    unless self.valid_move_seq?(seq)
      raise InvalidMoveError
    else
      self.perform_moves!(seq)
    end
  end

  def new_pos(pos)
    self.board[self.pos] = nil
    self.pos = pos
    self.board[pos] = self
  end

  def killer_move(pos)
    opp_piece = self.board[pos]
    opp_piece.pos = nil
    self.board[pos] = nil
  end

  def render
    (self.color == :red ) ? string = "|O|".red : string ="|X|".black
    string = string.blink if self.upgrade
    string
  end

end
