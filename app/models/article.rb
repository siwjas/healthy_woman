class Article < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :content_image_removal
  attr_accessor :cover_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_rich_text :content
  has_one_attached :content_image
  has_one_attached :cover
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :title, presence: true
  # 🚅 add validations above.

  after_validation :remove_content_image, if: :content_image_removal?
  after_validation :remove_cover, if: :cover_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def content_image_removal?
    content_image_removal.present?
  end

  def remove_content_image
    content_image.purge
  end

  def cover_removal?
    cover_removal.present?
  end

  def remove_cover
    cover.purge
  end

  # 🚅 add methods above.
end
