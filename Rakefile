$: << File.expand_path("../lib",__FILE__)
require 'tyrion'

namespace :db do
	desc "run migration"
	task :migrate do
		ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate File.expand_path("../lib/tyrion/migrations", __FILE__)
	end
end
