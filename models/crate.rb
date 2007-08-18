class Crate < MobilePiece
  def self.represented_by?(char)
    true if ["o", "*"].include?(char)
  end

  def valid_new_location?(x, y)
    x_diff = (self.x - x).abs
    y_diff = (self.y - y).abs

    return false unless x_diff + y_diff == 1

    pieces_in_square = @stage.pieces_for(x, y).map{|p| p.class}
    !pieces_in_square.include_any?(Crate, Wall, Guy)
  end
end
