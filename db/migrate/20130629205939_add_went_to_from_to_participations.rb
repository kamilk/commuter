class AddWentToFromToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :went_to,   :boolean, default: true
    add_column :participations, :went_from, :boolean, default: true
  end
end
