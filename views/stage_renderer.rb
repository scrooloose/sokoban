class StageRenderer
  class UnknownPieceCombo < StandardError; end
  include HighLine::SystemExtensions

  def initialize(stage, controller)
    @controller = controller
    @stage = stage
    @show_help = false
  end
  
  def render
    output = "#{(File.basename(@stage.filename))}\n\n".color(:yellow)
    
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
      "o".color(:fg => :green, :bg => :cyan)
    elsif pieces.include_all?(Guy, StorageArea)
      "@".color(:fg => :magenta, :bg => :cyan)
    elsif pieces.include_all?(Guy, Floor)
      "@".color(:magenta)
    elsif pieces.include?(StorageArea)
      ".".color(:bg => :cyan)
    elsif pieces.include?(Crate)
      "o".color(:green)
    elsif pieces.include?(Wall)
      "#"
    elsif pieces.include?(Floor)
      " "
    else
      raise(UnknownPieceCombo, "Dont know how to render [#{pieces}]")
    end
  end

  def help_string
    keys = AppConfig.keys.dup
    keys.each {|k,v| keys[k] = v.chr}

    if @show_help
      output =  "Movement keys:\n"
      output << "        #{keys[:up].color(:red)}\n"
      output << "     #{keys[:left].color(:red)}     #{keys[:right].color(:red)}\n"
      output << "        #{keys[:down].color(:red)}\n\n"
      output << "Quit: #{keys[:quit].color(:red)}\n"
      output << "Restart: #{keys[:restart].color(:red)}\n"
      output << "Choose stage: #{keys[:choose_stage].color(:red)}\n"
      output << "Toggle help: #{keys[:help].color(:red)}"
    else
      output =  "Press #{keys[:help].color(:red)} for help"
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
