class AddMoreFieldsToBikes < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :brand, :string
    add_column :bikes, :model, :string
    add_column :bikes, :weight, :float
    add_column :bikes, :notes, :text
  end
end
