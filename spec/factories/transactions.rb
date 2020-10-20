FactoryBot.define do
  factory :transaction do
    association :invoice
    credit_card_numer { 123123123 }
    credit_card_expiration_date { "" }
    result { "Success" }
  end
end
