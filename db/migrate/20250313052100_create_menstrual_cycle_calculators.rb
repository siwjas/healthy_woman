class CreateMenstrualCycleCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :menstrual_cycle_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.date :last_period_date, null: false
      t.integer :cycle_length, default: 28
      t.integer :period_duration, default: 5
      t.date :fertility_window_start
      t.date :fertility_window_end
      t.date :ovulation_date
      t.date :next_period_date
      t.text :notes
      t.jsonb :symptoms
      
      t.timestamps
    end
    
    add_index :menstrual_cycle_calculators, [:user_id, :created_at]
  end
end
