class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.float "distance"
      t.integer "time"
      t.string "external_id"
      t.datetime "activity_date"
      t.string "name"
      t.boolean "commute"
      t.string "sport_type"

      t.timestamps
    end
  end
end
