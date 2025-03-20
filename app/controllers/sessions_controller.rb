# Ejected from `bullet_train-1.19.0/app/controllers/sessions_controller.rb`.

class SessionsController < Devise::SessionsController
  include Sessions::ControllerBase

  # Sobrescrever o método create para migrar dados dos cookies após login
  def create
    super do |user|
      migrate_bmi_data_from_cookies(user) if cookies.signed[:bmi_form_data].present?
    end
  end

  private

  def migrate_bmi_data_from_cookies(user)
    # Recuperar dados do cookie
    bmi_data = JSON.parse(cookies.signed[:bmi_form_data])
    bmi_result = cookies.signed[:bmi_result]
    
    # Criar um novo registro de BMI para o usuário
    user.bmi_calculators.create!(
      weight: bmi_data["weight"],
      height: bmi_data["height"] || user.height, # Usar altura do usuário se não estiver no cookie
      weight_goal: bmi_data["weight_goal"],
      notes: bmi_data["notes"],
      is_pregnant: user.is_pregnant # Usar o status de gravidez do usuário
    )
    
    # Limpar os cookies após migração
    cookies.delete(:bmi_form_data)
    cookies.delete(:bmi_result)
    
    # Adicionar mensagem de sucesso
    flash[:notice] = "Seus dados de IMC foram importados para sua conta!"
  end
end
