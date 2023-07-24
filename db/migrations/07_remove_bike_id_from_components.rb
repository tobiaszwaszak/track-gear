class RemoveBikeIdFromComponents < ActiveRecord::Migration[7.0]
  def change
    remove_column :components, :bike_id, :integer
  end
end
