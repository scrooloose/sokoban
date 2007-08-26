class StageSelectionController
  def self.run
    new.choose_stage
    nil
  end

  def choose_stage
    s = StageChooser.new(Stage.files)
    choice = s.prompt_user_to_choose
    c = Controller.run(File.join("data", choice));
  end

end
