$: << File.expand_path("../lib",__FILE__)

require 'tyrion/api'

STATIC_DIR = File.expand_path("../public/",__FILE__)

logger = Tyrion::Config.instance.api_logger
#This is a HACK - common logger get a file as an input, and as a result using write.
class << logger
  alias write info
end
use Rack::CommonLogger, logger

run Rack::Cascade.new [Tyrion::API, Rack::Directory.new(STATIC_DIR)]
