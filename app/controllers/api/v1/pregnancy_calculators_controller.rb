module Api
  module V1
    class PregnancyCalculatorsController < Api::V1::ApplicationController
      include Api::V1::Controllers::PregnancyCalculatorsConcern
      
      def index
        @pregnancy_calculators = @team.pregnancy_calculators
        render json: @pregnancy_calculators
      end

      def show
        render json: @pregnancy_calculator
      end
    end
  end
end 