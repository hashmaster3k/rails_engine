FactoryBot.define do
  factory :invoice_item do
    association :item
    association :invoice
    quantity { 2 }
    unit_price { 1.5 }
  end
end
