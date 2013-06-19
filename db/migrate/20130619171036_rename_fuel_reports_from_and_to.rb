class RenameFuelReportsFromAndTo < ActiveRecord::Migration
  def change
    rename_column :fuel_reports, :from, :from_date
    rename_column :fuel_reports, :to,   :to_date
  end
end
