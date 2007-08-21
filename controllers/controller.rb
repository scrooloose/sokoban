class Controller
  class InvalidStageName < StandardError; end

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
  end

  def load_stage
    @stage = Stage.parse(open(@stage_filename).readlines)
    @stage_renderer = StageRenderer.new(@stage)
    @stage_renderer.after_keypress do |key|
      key_pressed(key)
    end
    @stage_renderer.main_loop
  end

  def key_pressed(key)
    begin
      case key
      when AppConfig.keys[:quit]
        @stage_renderer.kill_main_loop
      when AppConfig.keys[:down]
        @stage.guy.move_down
      when AppConfig.keys[:left]
        @stage.guy.move_left
      when AppConfig.keys[:right]
        @stage.guy.move_right
      when AppConfig.keys[:up]
        @stage.guy.move_up
      when AppConfig.keys[:help]
        @stage_renderer.toggle_help
      when AppConfig.keys[:restart]
        @stage_renderer.kill_main_loop
        load_stage
        @stage.messages << "The game has been restarted"
      end
    rescue Movable::InvalidMoveError
      $stderr.puts "Cancelled the move" if $DEBUG
      @stage.messages << "Cancelled the move: #{$!.message}"
    end
  end

end
