# app/controllers/account/dashboard_controller.rb
class Account::DashboardController < Account::ApplicationController
  def index
    # Exibir dados básicos para todos os usuários
    @recent_pregnancy_calculators = current_team.pregnancy_calculators.order(created_at: :desc).limit(3)
    @recent_menstrual_cycle_calculators = current_team.menstrual_cycle_calculators.order(created_at: :desc).limit(3)
    @recent_bmi_calculators = current_team.bmi_calculators.order(created_at: :desc).limit(3)
    
    # Artigos e categorias para todos
    @recent_articles = current_team.articles_articles.order(created_at: :desc).limit(5)
    @recent_categories = current_team.articles_categories.order(created_at: :desc).limit(5)
  end
end