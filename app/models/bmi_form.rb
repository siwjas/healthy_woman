class BmiForm
  include ActiveModel::Model
  
  attr_accessor :weight, :height
  
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
end 