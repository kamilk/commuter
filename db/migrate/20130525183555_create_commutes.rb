class CreateCommutes < ActiveRecord::Migration
  def change
    create_table :commutes do |t|
      t.integer :driver_id
      t.date :date

      t.timestamps
    end

    add_index :commutes, :date
  end
end
