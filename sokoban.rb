class GamePiece
  attr_accessor :x, :y

  def initialize(x,y)
    self.x = x
    self.y = y
  end

  def self.represented_by?(char)
    raise NotImplementedError, "represented_by? has not been implemented"
  end

  def self.pieces_for(char, x, y)
    pieces = []
    [Guy].each do |klass|
      pieces << klass.new(x,y) if klass.represented_by?(char)
    end
    pieces
  end

end

class Guy < GamePiece
  def self.represented_by?(char)
    true if ["@", "+"].include?(char)
  end
end

class StageParser

  def self.parse(lines)
    pieces = []
    lines.each_with_index do |line, line_index|
      line = line.to_char_array
      line.each_with_index do |char, char_index|
        puts "current char: #{char}"
        pieces << GamePiece.pieces_for(char, char_index, line_index)
      end
    end

    pieces
  end
end

class String
  def to_char_array
    a = []
    each_byte do |b|
      a << b.chr
    end
    a
  end
end

