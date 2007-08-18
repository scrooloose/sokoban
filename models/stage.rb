class Stage
  def self.parse(lines)
    s = new
    pieces = []
    lines.each_with_index do |line, line_index|
      line = line.to_char_array.select{|c| c != "\n"}
      line.each_with_index do |char, char_index|
        pieces << GamePiece.pieces_for(char, char_index, line_index, s)
      end
    end

    s.pieces = pieces.flatten
    s
  end
  
  attr_accessor :pieces

  def initialize(pieces = nil)
    @pieces = pieces
  end

  def guy
    @guy ||= pieces.select{|p| p.instance_of? Guy}.first
  end

  def messages
    @messages ||= []
  end
  
  def display_messages
    messages.each do |m|
      yield m
    end
    @messages = nil
  end
  
  def analyse
    messages << "ALL RIGHT! YOU WIN YO!!" if won?
  end

  def pieces_for(x, y)
    @pieces.select{|p| p.x == x && p.y == y}
  end

  def board_dimensions
    @x_dimension ||= begin
      @pieces.inject(0) do |highest,p| 
        p.x > highest ? p.x : highest
      end
    end

    @y_dimension ||= begin
      @pieces.inject(0) do |highest,p| 
        p.y > highest ? p.y : highest
      end
    end

    [@x_dimension, @y_dimension]
  end

  def crates
    @crates ||= pieces.select{|p| p.instance_of?(Crate)}
  end

  def won?
    crates.each do |c|
      unless pieces_for(c.x, c.y).map{|p| p.class}.include?(StorageArea)
        return false
      end
    end

    true
  end
end
