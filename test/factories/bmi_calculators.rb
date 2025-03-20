FactoryBot.define do
  factory :bmi_calculator do
    team { nil }
    weight { 1 }
    height { 1 }
    bmi { 1 }
    weight_goal { 1 }
    notes { "MyText" }
  end
end
