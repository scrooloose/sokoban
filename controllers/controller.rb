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
    start_stage
  end

  def start_stage
    @stage = StageParser.parse(open(@stage_filename).readlines)
    @stage_renderer = StageRenderer.new(@stage)
    key_loop
  end

  def restart_stage
    start_stage
  end

  def key_loop
    
    done = false

    while !done
      @stage_renderer.render
      key = get_character

      begin
        case key
        when AppConfig.keys[:quit].to_s[0]
          puts "Quitting"
          break
        when AppConfig.keys[:down].to_s[0]
          @stage.guy.move_down
        when AppConfig.keys[:left].to_s[0]
          @stage.guy.move_left
        when AppConfig.keys[:right].to_s[0]
          @stage.guy.move_right
        when AppConfig.keys[:up].to_s[0]
          @stage.guy.move_up
        when AppConfig.keys[:restart].to_s[0]
          done = true
          restart_stage
        end
      rescue
        puts "Illegal move yo"
      end
    end
  end

end
