class Account::MigrateCalculatorDataController < Account::ApplicationController
  def create
    success = true
    
    # Migrar dados da calculadora de gravidez
    if params[:pregnancy_data].present?
      pregnancy_calculator = current_team.pregnancy_calculators.new(
        user: current_user,
        last_menstrual_period_date: Date.parse(params[:pregnancy_data][:lastMenstrualPeriodDate]),
        notes: "Migrado do navegador após login"
      )
      success = false unless pregnancy_calculator.save
    end
    
    # Migrar dados da calculadora de ciclo menstrual
    # ...
    
    # Migrar dados da calculadora de IMC
    # ...
    
    render json: { success: success }
  end
end 