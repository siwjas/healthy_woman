class Articles::Article < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :cover_image_removal, :category_ids
  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  # Nova relação muitos-para-muitos com categorias
  has_many :categorizations, class_name: "Articles::Categorization", foreign_key: :article_id, dependent: :destroy
  has_many :categories, through: :categorizations, class_name: "Articles::Category"
  # 🚅 add has_many associations above.
  has_rich_text :content
  has_one_attached :cover_image
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :title, presence: true
  # 🚅 add validations above.

  after_validation :remove_cover_image, if: :cover_image_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  belongs_to :category, class_name: 'Articles::Category'

  def cover_image_removal?
    cover_image_removal.present?
  end

  def remove_cover_image
    cover_image.purge
  end

  # 🚅 add methods above.
end
