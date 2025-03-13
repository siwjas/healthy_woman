class Articles::Category < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  # Relação antiga (será removida após migração completa)
  has_many :old_articles, class_name: "Articles::Article", dependent: :nullify, foreign_key: :category_id, inverse_of: :category
  
  # Nova relação muitos-para-muitos com artigos
  has_many :categorizations, class_name: "Articles::Categorization", foreign_key: :category_id, dependent: :destroy
  has_many :articles, through: :categorizations, class_name: "Articles::Article", enable_cable_ready_updates: true
  # 🚅 add has_many associations above.

  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
