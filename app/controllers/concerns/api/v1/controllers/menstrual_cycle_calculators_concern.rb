module Api::V1::Controllers::MenstrualCycleCalculatorsConcern
  extend ActiveSupport::Concern

  module StrongParameters
    def menstrual_cycle_calculator_params
      params.require(:menstrual_cycle_calculator).permit(
        :last_period_date,
        :cycle_length,
        :notes
      )
    end
  end

  included do
    include StrongParameters
    before_action :set_team, only: [:index]
    before_action :set_menstrual_cycle_calculator, only: [:show]
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_menstrual_cycle_calculator
    @menstrual_cycle_calculator = MenstrualCycleCalculator.find(params[:id])
  end
end 