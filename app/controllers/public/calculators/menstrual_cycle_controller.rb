class Public::Calculators::MenstrualCycleController < Public::ApplicationController
  def index
    # Recupera o último cálculo da sessão, se existir
    @last_calculation = session[:last_menstrual_cycle_calculation]
    @menstrual_cycle_calculator = MenstrualCycleCalculator.new
  end

  def calculate
    # Cria um novo cálculo baseado nos parâmetros
    @menstrual_cycle_calculator = MenstrualCycleCalculator.new(menstrual_cycle_calculator_params)
    
    # Executa os cálculos
    @menstrual_cycle_calculator.calculate_fertility_window
    @menstrual_cycle_calculator.calculate_next_period
    
    # Armazena o resultado na sessão
    session[:last_menstrual_cycle_calculation] = {
      last_period_date: @menstrual_cycle_calculator.last_period_date,
      cycle_length: @menstrual_cycle_calculator.cycle_length,
      fertility_window_start: @menstrual_cycle_calculator.fertility_window_start,
      fertility_window_end: @menstrual_cycle_calculator.fertility_window_end,
      ovulation_date: @menstrual_cycle_calculator.ovulation_date,
      next_period_date: @menstrual_cycle_calculator.next_period_date,
      created_at: Time.current
    }
    
    render :result
  end

  private

  def menstrual_cycle_calculator_params
    params.require(:menstrual_cycle_calculator).permit(:last_period_date, :cycle_length)
  end
end
