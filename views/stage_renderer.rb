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
