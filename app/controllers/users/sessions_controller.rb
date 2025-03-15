# app/controllers/users/sessions_controller.rb
def create
    super
    migrate_session_calculations_to_user if session[:last_pregnancy_calculation].present?
  end
  
  private
  
  def migrate_session_calculations_to_user
    # Migrar calculadora de gravidez
    if session[:last_pregnancy_calculation].present?
      current_user.pregnancy_calculators.create(
        last_menstrual_period_date: session[:last_pregnancy_calculation][:last_menstrual_period_date],
        notes: "Cálculo migrado da sessão"
      )
      session.delete(:last_pregnancy_calculation)
    end
    
    # Fazer o mesmo para as outras calculadoras...
  end