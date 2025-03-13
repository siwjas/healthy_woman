class Public::ArticlesController < Public::ApplicationController
  def index
    @categories = Articles::Category.all
    # Atualizado para usar a nova relação muitos-para-muitos
    @articles = Articles::Article.all.includes(:categories).order(created_at: :desc)
  end
  
  def show
    @article = Articles::Article.find(params[:id])
    # Carrega as categorias do artigo
    @categories = @article.categories
  end
  
  def category
    @category = Articles::Category.find(params[:id])
    # Atualizado para usar a nova relação muitos-para-muitos
    @articles = @category.articles.order(created_at: :desc)
  end
end
