class BmiForm
  include ActiveModel::Model
  
  attr_accessor :weight, :height, :weight_goal, :notes
  
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :weight_goal, numericality: { greater_than: 0 }, allow_blank: true

  def initialize(attributes = {})
    super
    @weight = attributes[:weight]
    @height = attributes[:height]
    @weight_goal = attributes[:weight_goal]
    @notes = attributes[:notes]
  end
end 