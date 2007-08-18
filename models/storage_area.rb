class StorageArea < GamePiece
  def self.represented_by?(char)
    [".", '*', '+'].include?(char)
  end
end
