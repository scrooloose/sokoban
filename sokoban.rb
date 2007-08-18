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

class MobilePiece < GamePiece
  class InvalidMoveError < StandardError; end

  def valid_new_location?(x, y)
    raise NotImplementedError, "valid_new_location? has not been implemented"
  end

  def move_down
    move(0, 1)
  end

  def move_left
    move(-1, 0)
  end

  def move_right
    move(1, 0)
  end

  def move_up
    move(0, -1)
  end

  def move(xdiff, ydiff)
    xnew, ynew = x + xdiff, y + ydiff
    raise(InvalidMoveError, "Cannot move to #{xnew}, #{ynew}") unless valid_new_location?(xnew, ynew)
    self.x = xnew
    self.y = ynew
  end
end

class Guy < MobilePiece
  def self.represented_by?(char)
    true if ["@", "+"].include?(char)
  end

  def valid_new_location?(x, y)
    pieces_on_square = @stage.pieces_for(x,y).map{|p| p.class}
    !pieces_on_square.include_any?(Wall)
  end

  def to_s
    "Guy--- X:#{x}, Y:#{y}"
  end

  def move(xdiff, ydiff)
    puts xdiff, ydiff
    xnew, ynew = x + xdiff, y + ydiff
    unless valid_new_location?(xnew,ynew)
      raise(InvalidMoveError, "Cannot move guy to #{xnew},#{ynew}")
    end
    
    pieces_on_square = @stage.pieces_for(xnew, ynew)
    puts pieces_on_square.map{|p| p.class}.inspect
    pieces_on_square.each do |piece|
      piece.move(xdiff, ydiff) if piece.instance_of? Crate
    end

    self.x = xnew
    self.y = ynew
  end
end

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

class Wall < GamePiece
  def self.represented_by?(char)
    char == "#"
  end
end

class StorageArea < GamePiece
  def self.represented_by?(char)
    [".", '*', '+'].include?(char)
  end
end

class Floor < GamePiece
  def self.represented_by?(char)
    [' ', '@', 'o'].include?(char)
  end
end

class StageParser
  def self.parse(lines)
    s = Stage.new
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
end

class Stage
  attr_accessor :pieces

  def initialize(pieces = nil)
    @pieces = pieces
  end

  def guy
    @guy ||= pieces.select{|p| p.instance_of? Guy}.first
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
    @x_dimension

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

class StageRenderer
  class UnknownPieceCombo < StandardError; end

  def initialize(stage)
    @stage = stage
  end
  
  def render
    x_dim, y_dim = @stage.board_dimensions

    system("clear")

    puts "ALL RIGHT! YOU WIN YO!!" if @stage.won?


    0.upto(y_dim) do |y|
      0.upto(x_dim) do |x|
        pieces = @stage.pieces_for(x, y)
        putc char_for_pieces(pieces) if pieces.any?
      end
      putc "\n"
    end
  end

  def char_for_pieces(pieces)
    pieces = pieces.map{|x| x.class}
    if pieces.include_all?(Crate, StorageArea)
      "*"
    elsif pieces.include_all?(Guy, StorageArea)
      "+"
    elsif pieces.include_all?(Guy, Floor)
      "@"
    elsif pieces.include?(StorageArea)
      "."
    elsif pieces.include?(Crate)
      "o"
    elsif pieces.include?(Wall)
      "#"
    elsif pieces.include?(Floor)
      " "
    else
      raise(UnknownPieceCombo, "Dont know how to render [#{pieces}]")
    end
  end
end

require "rubygems"
gem "highline"
require "highline/system_extensions"

class Controller
  def self.run(name)
    new(name)
    nil
  end
  
  def initialize(name)
    @stage = StageParser.parse(open(name).readlines)
    @stage_renderer = StageRenderer.new(@stage)
    key_loop
  end
  
  include HighLine::SystemExtensions

  def key_loop
    loop do
      @stage_renderer.render
      key = get_character

      begin
        case key
        when ?q
          puts "Quitting"
          break
        when ?2
          @stage.guy.move_down
        when ?4
          @stage.guy.move_left
        when ?6
          @stage.guy.move_right
        when ?8
          @stage.guy.move_up
        end
      rescue
        puts "Illegal move yo"
      end
    end
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

class Array
  def include_all?(*objs)
    objs.each do |obj|
      return false unless include?(obj)
    end
    true
  end

  def include_any?(*objs)
    objs.each do |obj|
      return true if include?(obj)
    end
    false
  end
end


