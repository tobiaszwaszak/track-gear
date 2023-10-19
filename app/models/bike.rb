module App
  module Models
    class Bike < Data.define(:id, :name, :brand, :model, :weight, :notes, :distance, :time, :sport_type, :commute)
    end
  end
end
