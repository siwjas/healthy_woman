module Api
  module V1
    class MenstrualCycleCalculatorsController < Api::V1::ApplicationController
      include Api::V1::Controllers::MenstrualCycleCalculatorsConcern
      
      def index
        @menstrual_cycle_calculators = @team.menstrual_cycle_calculators
        render json: @menstrual_cycle_calculators
      end

      def show
        render json: @menstrual_cycle_calculator
      end
    end
  end
end 