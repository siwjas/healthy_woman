class Public::Calculators::PregnancyController < Public::ApplicationController
  def index
    # Apenas renderiza a view - toda a lógica está no JavaScript
  end

  def calculate
    # Cria um novo cálculo baseado nos parâmetros
    @pregnancy_calculator = PregnancyCalculator.new(pregnancy_calculator_params)
    
    # Executa os cálculos
    @pregnancy_calculator.calculate_due_date
    @pregnancy_calculator.calculate_gestational_age
    
    # Armazena o resultado na sessão
    session[:last_pregnancy_calculation] = {
      last_menstrual_period_date: @pregnancy_calculator.last_menstrual_period_date,
      due_date: @pregnancy_calculator.due_date,
      weeks: @pregnancy_calculator.weeks,
      days: @pregnancy_calculator.days,
      trimester: @pregnancy_calculator.current_trimester,
      created_at: Time.current
    }
    
    render :result
  end

  private

  def pregnancy_calculator_params
    params.require(:pregnancy_calculator).permit(:last_menstrual_period_date, :notes)
  end
end
