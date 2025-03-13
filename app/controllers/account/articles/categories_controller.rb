class Account::Articles::CategoriesController < Account::ApplicationController
  account_load_and_authorize_resource :category, through: :team, through_association: :articles_categories

  # GET /account/teams/:team_id/articles/categories
  # GET /account/teams/:team_id/articles/categories.json
  def index
    delegate_json_to_api
  end

  # GET /account/articles/categories/:id
  # GET /account/articles/categories/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/articles/categories/new
  def new
  end

  # GET /account/articles/categories/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/articles/categories
  # POST /account/teams/:team_id/articles/categories.json
  def create
    respond_to do |format|
      if @category.save
        format.html { redirect_to [:account, @category], notice: I18n.t("articles/categories.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @category] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/articles/categories/:id
  # PATCH/PUT /account/articles/categories/:id.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:account, @category], notice: I18n.t("articles/categories.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @category] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/articles/categories/:id
  # DELETE /account/articles/categories/:id.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :articles_categories], notice: I18n.t("articles/categories.notifications.destroyed") }
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
