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
        when AppConfig.keys[:quit][0]
          puts "Quitting"
          break
        when AppConfig.keys[:down][0]
          @stage.guy.move_down
        when AppConfig.keys[:left][0]
          @stage.guy.move_left
        when AppConfig.keys[:right][0]
          @stage.guy.move_right
        when AppConfig.keys[:up][0]
          @stage.guy.move_up
        end
      rescue
        puts "Illegal move yo"
      end
    end
  end
end
