class AddMoreFieldsToComponents < ActiveRecord::Migration[7.0]
  def change
    add_column :components, :brand, :string
    add_column :components, :model, :string
    add_column :components, :weight, :float
    add_column :components, :notes, :text
  end
end
