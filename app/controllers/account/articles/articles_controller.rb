class Account::Articles::ArticlesController < Account::ApplicationController
  # Modificado para não depender de uma única categoria
  account_load_and_authorize_resource :article, through: :team, through_association: :articles_articles

  # GET /account/articles
  # GET /account/articles.json
  def index
    # Carrega todas as categorias do time atual para o seletor de categorias
    @categories = current_team.articles_categories
    delegate_json_to_api
  end

  # GET /account/articles/articles/:id
  # GET /account/articles/articles/:id.json
  def show
    @article = Articles::Article.find(params[:id])
    # Se o artigo pertence a uma categoria, devemos carregá-la:
    @category = @article.categories.first if @article.categories.any?
    delegate_json_to_api
  end

  # GET /account/articles/new
  def new
    # Carrega todas as categorias do time atual para o seletor de categorias
    @categories = current_team.articles_categories
  end

  # GET /account/articles/articles/:id/edit
  def edit
    # Carrega todas as categorias do time atual para o seletor de categorias
    @categories = current_team.articles_categories
  end

  # POST /account/articles
  # POST /account/articles.json
  def create
    # Associa o artigo ao time atual
    @article.team = current_team
    
    respond_to do |format|
      if @article.save
        # Processa as categorias selecionadas
        process_categories
        
        format.html { redirect_to [:account, @article], notice: I18n.t("articles/articles.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @article] }
      else
        @categories = current_team.articles_categories
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/articles/articles/:id
  # PATCH/PUT /account/articles/articles/:id.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        # Processa as categorias selecionadas
        process_categories
        
        format.html { redirect_to [:account, @article], notice: I18n.t("articles/articles.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @article] }
      else
        @categories = current_team.articles_categories
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/articles/articles/:id
  # DELETE /account/articles/articles/:id.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to [:account, :articles], notice: I18n.t("articles/articles.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # Permite parâmetros para múltiplas categorias
    strong_params.permit(:category_ids => [])
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
  
  # Processa as categorias selecionadas no formulário
  def process_categories
    # Limpa as categorizações existentes
    @article.categorizations.destroy_all
    
    # Adiciona as novas categorias selecionadas
    if params[:article] && params[:article][:category_ids].present?
      params[:article][:category_ids].reject(&:blank?).each do |category_id|
        category = Articles::Category.find_by(id: category_id)
        if category && category.team_id == current_team.id
          # Cria a categorização, definindo a primeira como primária
          is_primary = @article.categorizations.empty?
          @article.categorizations.create(category: category, is_primary: is_primary)
        end
      end
    end
  end
end
