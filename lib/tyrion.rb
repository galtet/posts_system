module Tyrion; end

require 'mysql2'

require 'tyrion/exceptions'
require 'tyrion/wrapped_logging'
require 'tyrion/config'
require 'tyrion/api'

require 'tyrion/models/user'
require 'tyrion/models/post'
require 'tyrion/models/vote'

module Tyrion::Models; end

# HACK: this is needed since we initialize the DB inside the config object.
Tyrion::Config.instance

