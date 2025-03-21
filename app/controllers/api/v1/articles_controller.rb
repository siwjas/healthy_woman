# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ArticlesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :article, through: :team, through_association: :articles

    # GET /api/v1/teams/:team_id/articles
    def index
    end

    # GET /api/v1/articles/:id
    def show
    end

    # POST /api/v1/teams/:team_id/articles
    def create
      if @article.save
        render :show, status: :created, location: [:api, :v1, @article]
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/articles/:id
    def update
      if @article.update(article_params)
        render :show
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/articles/:id
    def destroy
      @article.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def article_params
        strong_params = params.require(:article).permit(
          *permitted_fields,
          :title,
          :content,
          :content_image,
          :content_image_removal,
          :cover,
          :cover_removal,
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
  class Api::V1::ArticlesController
  end
end
