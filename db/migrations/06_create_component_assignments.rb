class CreateComponentAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :component_assignments do |t|
      t.references :bike, foreign_key: true
      t.references :component, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end