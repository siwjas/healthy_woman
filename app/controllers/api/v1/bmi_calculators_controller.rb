module Api
  module V1
    class BmiCalculatorsController < Api::V1::ApplicationController
      include Api::V1::Controllers::BmiCalculatorsConcern
      
      # GET /api/v1/teams/:team_id/bmi_calculators
      def index
        @bmi_calculators = @team.bmi_calculators
        render json: @bmi_calculators
      end

      # GET /api/v1/bmi_calculators/:id
      def show
        render json: @bmi_calculator
      end
    end
  end
end 