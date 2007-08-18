class Guy < GamePiece
  represented_by "@", "+"
  include Movable
  blocked_by :Wall

  def to_s
    "Guy--- X:#{x}, Y:#{y}"
  end
  
  before_move :move_crates
  def move_crates(xdiff, ydiff)
    @stage.pieces_for(*position_for(xdiff, ydiff)).each do |piece|
      piece.move(xdiff, ydiff) if piece.instance_of? Crate
    end  
  end
end
