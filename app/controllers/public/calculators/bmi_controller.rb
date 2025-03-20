class Public::Calculators::BmiController < ApplicationController
  layout 'public'
  # Removendo o concern que requer autenticação
  # include Api::V1::Controllers::BmiCalculatorsConcern

  def index
    Rails.logger.debug "Cookies no index: #{cookies.to_h}"
    
    if cookies.signed[:bmi_form_data].present?
      form_data = JSON.parse(cookies.signed[:bmi_form_data])
      Rails.logger.debug "Dados carregados do cookie: #{form_data.inspect}"
      
      @bmi_form = Public::Calculators::BmiForm.new
      @bmi_form.attributes = form_data
      Rails.logger.debug "Form object após carregar: #{@bmi_form.attributes}"
    else
      @bmi_form = Public::Calculators::BmiForm.new
    end
    
    @result = cookies.signed[:bmi_result]
  end

  def calculate
    @bmi_form = Public::Calculators::BmiForm.new(bmi_params)
    
    if @bmi_form.valid?
      weight = @bmi_form.weight.to_f
      height = @bmi_form.height.to_f
      bmi = (weight / (height * height)).round(2)
      
      # Calcula o resultado
      @result = case bmi
        when 0..18.5 then "IMC #{bmi} - Abaixo do peso"
        when 18.5..24.99 then "IMC #{bmi} - Peso normal"
        when 24.9..29.99 then "IMC #{bmi} - Sobrepeso"
        when 29.9..34.99 then "IMC #{bmi} - Obesidade grau 1"
        when 34.9..39.99 then "IMC #{bmi} - Obesidade grau 2"
        else "IMC #{bmi} - Obesidade grau 3"
      end
      
      # Salva os dados nos cookies
      form_data = bmi_params.to_h
      cookies.signed[:bmi_form_data] = {
        value: form_data.to_json,
        expires: 1.week.from_now
      }
      
      cookies.signed[:bmi_result] = {
        value: @result,
        expires: 1.week.from_now
      }
      
      redirect_to calculators_bmi_path, notice: "IMC calculado com sucesso!"
    else
      flash.now[:alert] = "Por favor, insira valores válidos"
      render :index
    end
  end

  private

  def bmi_params
    params.require(:public_calculators_bmi_form).permit(:weight, :height, :weight_goal, :notes)
  end
end 