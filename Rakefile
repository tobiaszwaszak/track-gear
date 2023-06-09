require "yaml"
require "logger"
require "active_record"
require "byebug"

include ActiveRecord::Tasks

class Seeder
  def initialize(seed_file)
    @seed_file = seed_file
  end

  def load_seed
    raise "Seed file '#{@seed_file}' does not exist" unless File.file?(@seed_file)
    load @seed_file
  end
end

root = File.expand_path "..", __FILE__
DatabaseTasks.env = ENV["RACK_ENV"] || "development"
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(root, "db/configuration.yml")))
DatabaseTasks.db_dir = File.join root, "db"
DatabaseTasks.fixtures_path = File.join root, "spec/fixtures"
DatabaseTasks.migrations_paths = [File.join(root, "db/migrations")]
DatabaseTasks.seed_loader = Seeder.new File.join root, "db/seeds.rb"
DatabaseTasks.root = root

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load "active_record/railties/databases.rake"
