class Account::ArticlesController < Account::ApplicationController
  account_load_and_authorize_resource :article, through: :team, through_association: :articles

  # GET /account/teams/:team_id/articles
  # GET /account/teams/:team_id/articles.json
  def index
    delegate_json_to_api
  end

  # GET /account/articles/:id
  # GET /account/articles/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/articles/new
  def new
  end

  # GET /account/articles/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/articles
  # POST /account/teams/:team_id/articles.json
  def create
    respond_to do |format|
      if @article.save
        format.html { redirect_to [:account, @article], notice: I18n.t("articles.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @article] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/articles/:id
  # PATCH/PUT /account/articles/:id.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to [:account, @article], notice: I18n.t("articles.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @article] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/articles/:id
  # DELETE /account/articles/:id.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :articles], notice: I18n.t("articles.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
