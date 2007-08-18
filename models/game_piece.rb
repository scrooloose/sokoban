class GamePiece
  class InvalidLevelCharacter < StandardError; end
  attr_accessor :x, :y, :stage

  def initialize(x, y, stage)
    self.x = x
    self.y = y
    self.stage = stage
  end

  def self.represented_by?(char)
    raise NotImplementedError, "represented_by? has not been implemented"
  end

  def self.pieces_for(char, x, y, stage)
    pieces = []
    [Guy, Crate, Wall, StorageArea, Floor].each do |klass|
      pieces << klass.new(x, y, stage) if klass.represented_by?(char)
    end

    raise(InvalidLevelCharacter, "Invalid character: \"#{char}\"") if pieces.empty?
    pieces
  end
end
