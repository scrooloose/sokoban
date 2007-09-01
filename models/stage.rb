class Stage
  class InvalidStageName < StandardError; end


  def self.files
    Dir.glob(File.join("data", "*txt"))
  end

  attr_reader :filename
  attr_accessor :pieces

  def initialize(filename)
    unless File.exist?(filename)
      raise(InvalidStageName, "No stage with filename #{filename} found")
    end
    @filename = filename
    @stage_file_lines ||= open(filename).readlines
  end

  def pieces
    @pieces ||= begin
      pieces = []
      @stage_file_lines.each_with_index do |line, line_index|
        line = line.to_char_array.reject{|c| c == "\n"}
        line.each_with_index do |char, char_index|
          pieces << GamePiece.pieces_for(char, char_index, line_index, self)
        end
      end
      pieces.flatten
    end
  end

  def reset!
    @pieces, @guy, @messages, @crates = nil
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
    pieces.select{|p| p.x == x && p.y == y}
  end

  def board_dimensions
    [x_dimension, y_dimension]
  end
    
  def x_dimension
    @x_dimension ||= pieces.max {|a,b| a.x <=> b.x}.x
  end

  def y_dimension
    @y_dimension ||= pieces.max {|a,b| a.y <=> b.y}.y
  end

  def crates
    @crates ||= pieces.select{|p| p.instance_of?(Crate)}
  end

  def won?
    crates.all? do |c|
      pieces_for(c.x, c.y).map{|p| p.class}.include?(StorageArea)
    end
  end
end
