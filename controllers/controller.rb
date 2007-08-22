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
    @stage_renderer = StageRenderer.new(@stage, self)
    @stage_renderer.main_loop
  end

  %w(up down left right).each do |direction|
    method = "move_#{direction}"
    define_method(method) do
      return if @stage.won?
      begin
        @stage.guy.send(method)
      rescue Movable::InvalidMoveError
      end
    end
  end

  def restart
    @stage_renderer.kill_main_loop
    load_stage
    @stage.messages << "The game has been restarted"
  end

  def quit
    @stage_renderer.kill_main_loop
  end

  def toggle_help
    @stage_renderer.toggle_help
  end

end
