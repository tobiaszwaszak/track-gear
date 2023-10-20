class AddDefaultTypesToBikes < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :sport_type, :string
    add_column :bikes, :commute, :boolean, default: false
  end
end
