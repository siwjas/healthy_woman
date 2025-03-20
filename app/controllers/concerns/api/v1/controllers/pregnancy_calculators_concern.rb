module Api::V1::Controllers::PregnancyCalculatorsConcern
  extend ActiveSupport::Concern

  module StrongParameters
    def pregnancy_calculator_params
      params.require(:pregnancy_calculator).permit(
        :last_menstrual_period_date,
        :notes
      )
    end
  end

  included do
    include StrongParameters
    before_action :set_team, only: [:index]
    before_action :set_pregnancy_calculator, only: [:show]
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_pregnancy_calculator
    @pregnancy_calculator = PregnancyCalculator.find(params[:id])
  end
end 