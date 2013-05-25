class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :commute_id

      t.timestamps
    end

    add_index :participations, :user_id
    add_index :participations, :commute_id
  end
end
