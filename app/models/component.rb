module App
  module Models
    class Component < Data.define(:id, :name, :brand, :model, :weight, :notes, :bike_id, :time, :distance)
    end
  end
end
