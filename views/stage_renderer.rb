class StageRenderer
  class UnknownPieceCombo < StandardError; end
  include HighLine::SystemExtensions

  def initialize(stage, controller)
    @controller = controller
    @stage = stage
    @show_help = false
  end
  
  def render
    output = "#{File.basename(@stage.filename)}\n\n"
    
    0.upto(@stage.y_dimension) do |y|
      0.upto(@stage.x_dimension) do |x|
        pieces = @stage.pieces_for(x, y)
        output << char_for_pieces(pieces) if pieces.any?
      end
      output << "\n"
    end
    
    output << "\n"
    @stage.analyse
    @stage.display_messages do |message|
      output << "#{message}\n"
    end

    output << "\n\n#{help_string}\n"

    system("clear")
    puts output
  end

  def toggle_help
    @show_help = !@show_help
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

  def red(text)
    color_text("\e[1;31;40m", text)
  end

  def help_string
    keys = AppConfig.keys.dup
    keys.each {|k,v| keys[k] = v.chr}

    if @show_help
      output =  "Movement keys:\n"
      output << "        #{red(keys[:up])}\n"
      output << "     #{red(keys[:left])}     #{red(keys[:right])}\n"
      output << "        #{red(keys[:down])}\n\n"
      output << "Quit: #{red(keys[:quit])}\n"
      output << "Restart: #{red(keys[:restart])}\n"
      output << "Choose stage: #{red(keys[:choose_stage])}\n"
      output << "Toggle help: #{red(keys[:help])}"
    else
      output =  "Press #{red(keys[:help])} for help"
    end
    output
  end

  def main_loop
    @done = false
    while !@done
      render
      key = get_character

      case key
      when AppConfig.keys[:quit]
        @controller.quit
      when AppConfig.keys[:down]
        @controller.move_down
      when AppConfig.keys[:left]
        @controller.move_left
      when AppConfig.keys[:right]
        @controller.move_right
      when AppConfig.keys[:up]
        @controller.move_up
      when AppConfig.keys[:help]
        @controller.toggle_help
      when AppConfig.keys[:restart]
        @controller.restart
      when AppConfig.keys[:choose_stage]
        @controller.choose_stage
      end
    end
  end

  def kill_main_loop
    @done = true
  end

end
