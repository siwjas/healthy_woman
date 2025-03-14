class AddTeamToMenstrualCycleCalculators < ActiveRecord::Migration[8.0]
  def change
    add_reference :menstrual_cycle_calculators, :team, null: false, foreign_key: true
  end
end
