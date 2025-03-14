class Public::Calculators::BmiController < Public::ApplicationController
  def index
    # Recupera o último cálculo da sessão, se existir
    @last_calculation = session[:last_bmi_calculation]
    @bmi_calculator = BmiCalculator.new
  end

  def calculate
    # Cria um novo cálculo baseado nos parâmetros
    @bmi_calculator = BmiCalculator.new(bmi_calculator_params)
    
    # Executa os cálculos
    @bmi_calculator.calculate_bmi
    
    # Armazena o resultado na sessão
    session[:last_bmi_calculation] = {
      weight: @bmi_calculator.weight,
      height: @bmi_calculator.height,
      bmi: @bmi_calculator.bmi,
      category: @bmi_calculator.bmi_category,
      created_at: Time.current
    }
    
    render :result
  end

  private

  def bmi_calculator_params
    params.require(:bmi_calculator).permit(:weight, :height)
  end
end
