class Avo::Resources::ArticlesArticle < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Articles::Article
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :category, as: :belongs_to
    field :title, as: :text
    field :content, as: :textarea
    field :published, as: :text
  end
end
