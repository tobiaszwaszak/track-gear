class RemoveDescriptionFromComponents < ActiveRecord::Migration[7.0]
  def change
    remove_column :components, :description
  end
end
