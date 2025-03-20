class Team < ApplicationRecord
  include Teams::Base
  include Webhooks::Outgoing::TeamSupport
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  # has_many :articles_categories, class_name: "Articles::Category", dependent: :destroy
  
  has_many :articles, dependent: :destroy, enable_cable_ready_updates: true
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.

  has_many :pregnancy_calculators, dependent: :destroy
  has_many :menstrual_cycle_calculators, dependent: :destroy
  has_many :bmi_calculators, dependent: :destroy, enable_cable_ready_updates: true
end
