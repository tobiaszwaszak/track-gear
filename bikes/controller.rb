require "csv"
module Bikes
  class Controller
    def initialize
      @database = "bikes.csv"
    end

    def index(request)
      bikes = read_database

      [200, {"content-type" => "application/json"}, [bikes.to_json]]
    end

    def create(request)
      bike_data = JSON.parse(request.body.read)
      bikes = read_database
      bike_id = read_database.empty? ? 1 : read_database.map { |bike| bike["id"].to_i }.max + 1
      bike_data["id"] = bike_id
      bikes << bike_data
      write_database(bikes)
      [201, {"content-type" => "text/plain"}, ["Create"]]
    end

    def read(request, bike_id)
      bikes = read_database
      bike = bikes.find { |b| b["id"].to_i == bike_id }
      if bike
        [200, {"content-type" => "application/json"}, [bike.to_json]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def update(request, bike_id)
      bike_data = JSON.parse(request.body.read)
      bikes = read_database
      index = bikes.find_index { |b| b["id"].to_i == bike_id }
      if index
        bikes[index] = bike_data
        write_database(bikes)
        [200, {"content-type" => "text/plain"}, ["Update with ID #{bike_id}"]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def delete(request, bike_id)
      bikes = read_database
      index = bikes.find_index { |b| b["id"].to_i == bike_id }
      if index
        bikes.delete_at(index)
        write_database(bikes)
        [200, {"content-type" => "text/plain"}, ["Delete with ID #{bike_id}"]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    private

    def read_database
      CSV.read(@database, headers: true, header_converters: :symbol).map(&:to_h).map { |array| array.map { |key, v| [key.to_s, v] }.to_h }
    end

    def write_database(data)
      CSV.open(@database, "w", write_headers: true, headers: data.first&.keys) do |csv|
        data.each { |row| csv << row.values }
      end
    end
  end
end
