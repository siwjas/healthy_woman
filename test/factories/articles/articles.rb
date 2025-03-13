FactoryBot.define do
  factory :articles_article, class: 'Articles::Article' do
    association :category, factory: :articles_category
    title { "MyString" }
    content { "MyText" }
    published { "MyString" }
  end
end
