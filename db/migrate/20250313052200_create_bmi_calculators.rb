class CreateBmiCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :bmi_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :weight, precision: 5, scale: 2, null: false
      t.decimal :height, precision: 3, scale: 2, null: false
      t.decimal :bmi, precision: 4, scale: 2
      t.boolean :is_pregnant, default: false
      t.decimal :pre_pregnancy_weight, precision: 5, scale: 2
      t.decimal :weight_goal, precision: 5, scale: 2
      t.text :notes
      
      t.timestamps
    end
    
    add_index :bmi_calculators, [:user_id, :created_at]
  end
end
