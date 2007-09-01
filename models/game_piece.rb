require 'set'

class GamePiece
  class InvalidLevelCharacter < StandardError; end
  class GamePieceNotConfigured < StandardError; end
  attr_reader :x, :y, :stage

  def initialize(x, y, stage)
    @x, @y, @stage = x, y, stage
  end

  def self.piece_classes
    @piece_classes ||= Set.new
  end

  def self.inherited(base)
    piece_classes << base
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
    piece_classes.each do |klass|
      pieces << klass.new(x, y, stage) if klass.represented_by?(char)
    end

    raise(InvalidLevelCharacter, "Invalid character: \"#{char}\"") if pieces.empty?
    pieces
  end

  def to_s
    "#{self.class.name} (#{x}, #{y})"
  end

end
