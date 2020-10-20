FactoryBot.define do
  factory :invoice do
    association :customer
    association :merchant
    status { "MyString" }
  end
end
