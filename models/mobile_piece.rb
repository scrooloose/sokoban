class MobilePiece < GamePiece
  class InvalidMoveError < StandardError; end

  def valid_new_location?(x, y)
    raise NotImplementedError, "valid_new_location? has not been implemented"
  end

  def move_down
    move(0, 1)
  end

  def move_left
    move(-1, 0)
  end

  def move_right
    move(1, 0)
  end

  def move_up
    move(0, -1)
  end

  def move(xdiff, ydiff)
    xnew, ynew = x + xdiff, y + ydiff
    raise(InvalidMoveError, "Cannot move to #{xnew}, #{ynew}") unless valid_new_location?(xnew, ynew)
    self.x = xnew
    self.y = ynew
  end
end
