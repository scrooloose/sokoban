class Controller
  class InvalidStageName < StandardError; end
  include HighLine::SystemExtensions

  def self.run(name)
    new(name)
    nil
  end
  
  def initialize(name)
    unless File.exist?(name)
      raise(InvalidStageName, "No stage with filename #{name} found")
    end
    @stage_filename = name
    load_stage
    key_loop
  end

  def load_stage
    @stage = Stage.parse(open(@stage_filename).readlines)
    @stage_renderer = StageRenderer.new(@stage)
  end

  def key_loop
    loop do
      @stage.analyse
      @stage_renderer.render
      key = get_character

      begin
        case key
        when AppConfig.keys[:quit]
          puts "Quitting"
          break
        when AppConfig.keys[:down]
          @stage.guy.move_down
        when AppConfig.keys[:left]
          @stage.guy.move_left
        when AppConfig.keys[:right]
          @stage.guy.move_right
        when AppConfig.keys[:up]
          @stage.guy.move_up
        when AppConfig.keys[:restart]
          load_stage
          @stage.messages << "The game has been restarted"
        end
      rescue Movable::InvalidMoveError
        $stderr.puts "Cancelled the move" if $DEBUG
        @stage.messages << "Cancelled the move: #{$!.message}"
      end
    end
  end

end
