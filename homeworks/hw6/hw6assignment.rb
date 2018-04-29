# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # class array holding all the pieces and their rotations
  All_My_Pieces = All_Pieces +
    [
      [
        [[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]], # long 5 blocks (only needs two)
        [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]
      ],
      rotations([[0, 0], [0, -1], [0, 1], [-1, 1],[-1,0]]), # fat L
      rotations([[0, 0], [0, 1], [1, 1]]) # small L
    ]

    # class method to choose the next piece
    def self.next_piece (board)
      MyPiece.new(All_My_Pieces.sample, board)
    end

end

class MyBoard < Board

  def initialize (game)
    super(game)
    @cheating = false
    @current_block = MyPiece.next_piece(self)
  end

  def rotate_180
    rotate_clockwise
    rotate_clockwise
  end

  Cheat_Cost = 100

  def cheat
    if !@cheating
      if @score >= Cheat_Cost
        @score -= Cheat_Cost
        @cheating = true
      end
    end
  end

  # gets the next piece
  def next_piece
    if @cheating
      @current_block = MyPiece.new([[[0,0]]],self)
      @cheating = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    locations.size.times{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

end

class MyTetris < Tetris

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat})
  end

end
