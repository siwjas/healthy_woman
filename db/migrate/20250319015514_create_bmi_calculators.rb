class CreateBmiCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :bmi_calculators do |t|
      t.references :team, null: false, foreign_key: true
      t.decimal :weight, precision: 5, scale: 2            # 999.99
      t.decimal :height, precision: 3, scale: 2            # 1.99
      t.decimal :bmi, precision: 4, scale: 2               # 99.99
      t.decimal :weight_goal, precision: 5, scale: 2
      t.text :notes

      t.timestamps
    end
    add_index :bmi_calculators, [:team_id, :created_at]
  end
end
