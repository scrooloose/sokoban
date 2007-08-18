class Wall < GamePiece
  def self.represented_by?(char)
    char == "#"
  end
end
