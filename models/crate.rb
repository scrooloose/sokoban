class Crate < GamePiece
  class MovedTooFar < StandardError; end
  
  represented_by "o", "*"
  include Movable
  blocked_by :Wall, :Guy, :Crate
  
  before_move :moved_by_one?
  def moved_by_one?(xdiff, ydiff)
    raise MovedTooFar, "The crate got moved too far" if xdiff + ydiff == 1
  end
end
