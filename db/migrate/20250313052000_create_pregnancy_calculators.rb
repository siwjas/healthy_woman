class CreatePregnancyCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :pregnancy_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.date :last_menstrual_period_date, null: false
      t.date :due_date
      t.integer :weeks
      t.integer :days
      t.text :notes
      
      t.timestamps
    end
    
    add_index :pregnancy_calculators, [:user_id, :created_at]
  end
end
