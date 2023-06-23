class CreateComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :components do |t|
      t.references :bike
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
