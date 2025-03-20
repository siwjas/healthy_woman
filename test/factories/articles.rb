FactoryBot.define do
  factory :article do
    association :team
    title { "MyString" }
    content { "MyText" }
    content_image { nil }
    cover { nil }
  end
end
