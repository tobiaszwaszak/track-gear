require_relative "../db/records/component"
require "active_record"

module Components
  class Repository
    def initialize
      setup_database
    end

    def all
      Db::Records::Component.all
    end

    def all_by(filters)
      Db::Records::Component.where(filters)
    end

    def create(bike_id:, name:, description:)
      Db::Records::Component.create(
        bike_id: bike_id,
        name: name,
        description: description
      )
    end

    def find(id:)
      Db::Records::Component.find(id)
    end

    def update(id:, params:)
      record = find(id: id)
      record.update(params)
      record
    end

    def delete(id:)
      record = find(id: id)
      record.destroy!
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end
  end
end
