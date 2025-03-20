module Api::V1::Controllers::BmiCalculatorsConcern
  extend ActiveSupport::Concern

  # Adicionar o módulo StrongParameters
  module StrongParameters
    def bmi_calculator_params
      params.require(:bmi_calculator).permit(
        :weight,
        :height,
        :bmi,
        :is_pregnant,
        :pre_pregnancy_weight,
        :weight_goal,
        :notes
      )
    end
  end

  included do
    include StrongParameters
    before_action :set_team, only: [:index]
    before_action :set_bmi_calculator, only: [:show]
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_bmi_calculator
    @bmi_calculator = BmiCalculator.find(params[:id])
  end
end 