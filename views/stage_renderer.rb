class StageRenderer
  class UnknownPieceCombo < StandardError; end

  def initialize(stage)
    @stage = stage
  end
  
  def render
    x_dim, y_dim = @stage.board_dimensions

    system("clear")

    puts "ALL RIGHT! YOU WIN YO!!" if @stage.won?

    output = ''

    0.upto(y_dim) do |y|
      0.upto(x_dim) do |x|
        pieces = @stage.pieces_for(x, y)
        output << char_for_pieces(pieces) if pieces.any?
      end
      output << "\n"
    end
    puts output
  end

  def char_for_pieces(pieces)
    pieces = pieces.map{|x| x.class}
    if pieces.include_all?(Crate, StorageArea)
      color_text("\e[1;32;46m", "o")
    elsif pieces.include_all?(Guy, StorageArea)
      color_text("\e[1;35;46m", "@")
    elsif pieces.include_all?(Guy, Floor)
      color_text("\e[1;35;40m", "@")
    elsif pieces.include?(StorageArea)
      color_text("\e[1;30;46m", ".")
    elsif pieces.include?(Crate)
      color_text("\e[1;32;40m", "o")
    elsif pieces.include?(Wall)
      "#"
    elsif pieces.include?(Floor)
      " "
    else
      raise(UnknownPieceCombo, "Dont know how to render [#{pieces}]")
    end
  end

  def color_text(color, text)
    "#{color}#{text}\e[0m"
  end

end
