module App
  module Models
    class Bike < Data.define(:id, :name, :brand, :model, :weight, :notes, :distance, :time, :commute, :sport_types)
    end
  end
end
