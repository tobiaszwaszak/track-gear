require_relative "spec_helper"

RSpec.describe MultitenancyMiddleware do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.new do
      use MultitenancyMiddleware
      run lambda { |env| [200, {"Content-Type" => "text/plain"}, ["Hello, World!"]] }
    end
  end

  let(:tenant_id) { "test_tenant" }

  context "when the account_id is present in the request" do
    it "establishes a connection to the tenant-specific database" do
      with_temporary_database(tenant_id) do |db_path|
        ENV["DB_DIRECTORY"] = File.dirname(db_path) + "/"

        get "/", {}, {"account_id" => tenant_id}

        connection = ActiveRecord::Base.connection_pool
        expect(connection).not_to be_nil
        expect(connection.db_config.database).to eq(db_path)
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq("Hello, World!")
      end
    end
  end

  context "when the account_id is not present in the request" do
    it "establishes a connection to the default database" do
      get "/"

      connection = ActiveRecord::Base.connection_pool
      expect(connection).not_to be_nil
      expect(connection.db_config.database).to eq("db/test.sqlite3")
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Hello, World!")
    end
  end

  def with_temporary_database(tenant_id)
    temp_dir = Dir.mktmpdir
    db_path = File.join(temp_dir, "test_#{tenant_id}.sqlite3")

    begin
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)
      load "db/schema.rb"

      yield db_path
    ensure
      ActiveRecord::Base.remove_connection
      FileUtils.remove_entry(temp_dir)
    end
  end
end
