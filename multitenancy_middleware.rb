require "active_record"
class MultitenancyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    tenant_id = env["account_id"]
    if tenant_id
      unless File.exist?("#{ENV["DB_DIRECTORY"] + ENV["RACK_ENV"]}_#{tenant_id}.sqlite3")
        create_tenant_database(tenant_id)
      end
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "#{ENV["DB_DIRECTORY"] + ENV["RACK_ENV"]}_#{tenant_id}.sqlite3")
    else
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end

    @app.call(env)
  end

  private

  def create_tenant_database(tenant_id)
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "#{ENV["DB_DIRECTORY"] + ENV["RACK_ENV"]}_#{tenant_id}.sqlite3")
    ActiveRecord::MigrationContext.new("db/migrations").migrate
  end
end
