class CreateBikeSportTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :bike_sport_types do |t|
      t.references :bike, foreign_key: true
      t.references :sport_type, foreign_key: true

      t.timestamps
    end
  end
end
