class User < ApplicationRecord
  include Users::Base
  include Roles::User
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.
  has_many :pregnancy_calculators, dependent: :destroy
  has_many :menstrual_cycle_calculators, dependent: :destroy
  has_many :bmi_calculators, dependent: :destroy

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
  # Returns the full name of the user
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
