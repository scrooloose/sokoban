class Floor < GamePiece
  def self.represented_by?(char)
    [' ', '@', 'o'].include?(char)
  end
end
