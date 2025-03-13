# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Articles::CategoriesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :category, through: :team, through_association: :articles_categories

    # GET /api/v1/teams/:team_id/articles/categories
    def index
    end

    # GET /api/v1/articles/categories/:id
    def show
    end

    # POST /api/v1/teams/:team_id/articles/categories
    def create
      if @category.save
        render :show, status: :created, location: [:api, :v1, @category]
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/articles/categories/:id
    def update
      if @category.update(category_params)
        render :show
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/articles/categories/:id
    def destroy
      @category.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def category_params
        strong_params = params.require(:articles_category).permit(
          *permitted_fields,
          :name,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::Articles::CategoriesController
  end
end
