class StageChooser
  include Colorable

  def initialize(files)
    @choices = files.sort
  end

  def prompt_user_to_choose
    stage_names = @choices.map{|f| File.basename(f)}

    system("clear")
    puts yellow("Pick a stage:\n\n")
    HighLine.new.choose do |m|
      m.choices(*stage_names)
      m.flow = :columns_down
      m.list_option = 3
      m.responses[:no_completion] = "Please enter a stage number"
      m.responses[:ambiguous_completion] = "Please enter a stage number"
    end
  end
end

