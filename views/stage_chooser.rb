class StageChooser
  def initialize(files)
    @choices = files.sort
  end

  def prompt_user_to_choose
    stage_names = @choices.map{|f| File.basename(f)}

    system("clear")
    puts "Pick a stage:\n\n"
    HighLine.new.choose do |m|
      m.choices(*stage_names)
      m.flow = :columns_down
      m.list_option = 3
    end
  end
end

