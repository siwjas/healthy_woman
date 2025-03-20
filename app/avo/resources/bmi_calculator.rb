class Avo::Resources::BmiCalculator < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :weight, as: :number
    field :height, as: :number
    field :bmi, as: :number
    field :weight_goal, as: :number
    field :notes, as: :textarea
  end
end
