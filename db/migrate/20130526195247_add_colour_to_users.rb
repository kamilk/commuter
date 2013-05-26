class AddColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :colour, :string
  end
end
