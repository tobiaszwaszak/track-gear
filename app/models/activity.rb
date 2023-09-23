module App
  module Models
    class Bike < Data.define(:distance, :time, :external_id, :activity_date, :name)
    end
  end
end
