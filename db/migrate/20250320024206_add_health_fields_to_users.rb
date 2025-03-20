class AddHealthFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_pregnant, :boolean, default: false
  end
end 
