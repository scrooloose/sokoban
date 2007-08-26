require "rubygems"
gem "highline"
require "highline"
require "highline/system_extensions"


require 'models/game_piece'
require 'models/movable'
require 'models/guy'
require 'models/crate'
require 'models/floor'
require 'models/wall'
require 'models/storage_area'
require 'models/stage'

require 'controllers/controller'
require 'controllers/stage_selection_controller'

require 'views/stage_renderer'
require 'views/stage_chooser'

require 'lib/hacks'
require 'lib/conf'

::AppConfig = Conf.init_config("config.yml")


if level = ARGV.first 
  c = Controller.run(File.join("data", level));
else
  StageSelectionController.choose_stage
end
