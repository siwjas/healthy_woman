# app/controllers/account/dashboard_controller.rb
class Account::DashboardController < Account::ApplicationController
  def index
    # Exibir dados básicos para todos os usuários
    @users = current_team.users  
    # Artigos e categorias para todos
    @recent_articles = current_team.articles.order(created_at: :desc).limit(5)
    # Comentar a linha de categorias até criarmos o modelo Category
    # @recent_categories = current_team.categories.order(created_at: :desc).limit(5)
  end
end