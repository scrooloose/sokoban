class StageRenderer
  class UnknownPieceCombo < StandardError; end
  include HighLine::SystemExtensions

  def initialize(stage)
    @stage = stage
  end

  def after_keypress(&block)
    @after_keypress_callback = block
  end
  attr_reader :after_keypress_callback
  
  def render
    output = ''
    
    0.upto(@stage.y_dimension) do |y|
      0.upto(@stage.x_dimension) do |x|
        pieces = @stage.pieces_for(x, y)
        output << char_for_pieces(pieces) if pieces.any?
      end
      output << "\n"
    end
    
    output << "\n"
    @stage.display_messages do |message|
      output << "#{message}\n"
    end

    system("clear")
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

  def main_loop
    @done = false
    while !@done
      render
      key = get_character
      @after_keypress_callback.call(key)
    end
  end

  def kill_main_loop
    @done = true
  end



end
