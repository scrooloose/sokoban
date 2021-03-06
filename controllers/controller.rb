class Controller
  def self.run(name)
    new(name)
    nil
  end
  
  def initialize(name)
    @stage = Stage.new(name)
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
    @stage.reset!
    @stage.messages << "The game has been restarted"
  end

  def quit
    @stage_renderer.kill_main_loop
  end

  def toggle_help
    @stage_renderer.toggle_help
  end

  def choose_stage
    @stage_renderer.kill_main_loop
    StageSelectionController.run
  end

end
