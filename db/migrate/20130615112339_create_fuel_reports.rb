class CreateFuelReports < ActiveRecord::Migration
  def change
    create_table :fuel_reports do |t|
      t.integer :user_id
      t.date :from
      t.date :to
      t.decimal :price_per_km

      t.timestamps
    end
  end
end
