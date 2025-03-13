class BmiCalculator < ApplicationRecord
  # Associações
  belongs_to :user
  
  # Validações
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  
  # Callbacks
  before_save :calculate_bmi
  
  # Métodos
  def calculate_bmi
    # IMC = peso(kg) / altura²(m)
    self.bmi = (weight / (height * height)).round(2)
  end
  
  def bmi_category
    case bmi
    when 0..18.40
      'Abaixo do peso'
    when 18.5..24.99
      'Peso normal'
    when 25.0..29.90
      'Sobrepeso'
    when 30.0..34.99
      'Obesidade Grau I'
    when 35.0..39.99
      'Obesidade Grau II'
    else
      'Obesidade Grau III'
    end
  end
  
  def pregnancy_weight_category
    return nil unless user.pregnancy_calculators.exists?
    
    # Recomendações específicas de IMC para gravidez seriam implementadas aqui
    # Esta é uma versão simplificada
    if user.pregnancy_calculators.any?
      # Lógica personalizada para recomendações de peso na gravidez
    end
  end
end
