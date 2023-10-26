require_relative "../../app/records/activity"
require_relative "../../app/records/sport_type"

class AddSportTypeToActivity< ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :sport_type_id, :integer

    ::App::Records::Activity.find_each do |activity|
      sport_type = ::App::Records::SportType.find_or_create_by(name: activity.sport_type)
      activity.update(sport_type_id: sport_type.id)
    end

    remove_column :activities, :sport_type
  end
end
