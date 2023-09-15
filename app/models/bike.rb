module App
  module Models
    class Bike < Data.define(:id, :name, :brand, :model, :weight, :notes)
    end
  end
end
