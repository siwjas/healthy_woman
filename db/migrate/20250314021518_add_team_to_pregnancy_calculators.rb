class AddTeamToPregnancyCalculators < ActiveRecord::Migration[8.0]
  def change
    add_reference :pregnancy_calculators, :team, null: false, foreign_key: true
  end
end
