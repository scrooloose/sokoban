class Guy < MobilePiece
  def self.represented_by?(char)
    true if ["@", "+"].include?(char)
  end

  def valid_new_location?(x, y)
    pieces_on_square = @stage.pieces_for(x,y).map{|p| p.class}
    !pieces_on_square.include_any?(Wall)
  end

  def to_s
    "Guy--- X:#{x}, Y:#{y}"
  end

  def move(xdiff, ydiff)
    xnew, ynew = x + xdiff, y + ydiff
    unless valid_new_location?(xnew,ynew)
      raise(InvalidMoveError, "Cannot move guy to #{xnew},#{ynew}")
    end
    
    pieces_on_square = @stage.pieces_for(xnew, ynew)
    pieces_on_square.each do |piece|
      piece.move(xdiff, ydiff) if piece.instance_of? Crate
    end

    self.x = xnew
    self.y = ynew
  end
end
