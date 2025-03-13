class AddDateOfBirthToUsers < ActiveRecord::Migration[8.0]
  def change
    # A coluna height já foi adicionada em outra migração
    # add_column :users, :height, :decimal, precision: 5, scale: 2
    add_column :users, :date_of_birth, :date
  end
end
