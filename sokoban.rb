require "rubygems"
gem "highline"
require "highline/system_extensions"

require 'models/game_piece'
require 'models/mobile_piece'
require 'models/guy'
require 'models/crate'
require 'models/floor'
require 'models/wall'
require 'models/storage_area'
require 'models/stage'
require 'models/stage_parser'

require 'controllers/controller'
require 'lib/hacks'
require 'views/stage_renderer'

require 'lib/conf'

::AppConfig = Conf.init_config("config.yml")

level = ARGV.first || 'level_0.txt'

c = Controller.run(File.join("data", level));
