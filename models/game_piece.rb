class GamePiece
  class InvalidLevelCharacter < StandardError; end
  class GamePieceNotConfigured < StandardError; end
  attr_accessor :x, :y, :stage

  def initialize(x, y, stage)
    self.x = x
    self.y = y
    self.stage = stage
  end
  
  def self.represented_by(*chars)
    raise ArgumentError, "You must provide at least one character" if chars.empty?
    @represented_by = chars
  end

  def self.represented_by?(char)
    if @represented_by.nil? || @represented_by.empty?
      raise GamePieceNotConfigured, "This piece (#{self}) doesn't have any characters which represent it"
    end
    @represented_by.include?(char)
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
