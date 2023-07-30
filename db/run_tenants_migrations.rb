require "active_record"
require "dotenv"
require_relative "./records/account"

Dotenv.load(".env.development") if ENV["RACK_ENV"] == "development"
Dotenv.load(".env.test") if ENV["RACK_ENV"] == "test"

ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)

Db::Records::Account.find_each do |tenant|
  tenant_id = tenant.id
  db_config = {
    adapter: "sqlite3",
    database: "#{ENV["DB_DIRECTORY"] + ENV["RACK_ENV"]}_#{tenant_id}.sqlite3"
  }

  ActiveRecord::Base.establish_connection(db_config)

  ActiveRecord::Migration.verbose = false

  begin
    ActiveRecord::MigrationContext.new("db/migrations", ActiveRecord::SchemaMigration).migrate
  rescue => e
    puts "Migration failed for tenant #{tenant_id}: #{e.message}"
  end
  ActiveRecord::Base.remove_connection
end
