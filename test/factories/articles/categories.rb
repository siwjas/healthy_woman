FactoryBot.define do
  factory :articles_category, class: 'Articles::Category' do
    association :team
    name { "MyString" }
    description { "MyText" }
  end
end
