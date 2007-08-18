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
