require 'rails_helper'

RSpec.describe 'Merchant Facade' do
  it '#list_of_merchants_by_attribute()' do
    create_list(:merchant, 3)
    merchants = MerchantFacade.list_of_merchants_by_attribute('name', 'ring')
    expect(merchants.count).to eq(3)
    merchants = MerchantFacade.list_of_merchants_by_attribute('updated_at', Date.today.to_s)
    expect(merchants.count).to eq(3)
    merchants = MerchantFacade.list_of_merchants_by_attribute('created_at', Date.today.to_s)
    expect(merchants.count).to eq(3)
  end

  it '#first_merchant_by_attribute()' do
    create_list(:merchant, 3)
    merchant = MerchantFacade.first_merchant_by_attribute('name', 'ring')
    expect(merchant).to be_a(Merchant)
    merchant = MerchantFacade.first_merchant_by_attribute('updated_at', Date.today.to_s)
    expect(merchant).to be_a(Merchant)
    merchant = MerchantFacade.first_merchant_by_attribute('created_at', Date.today.to_s)
    expect(merchant).to be_a(Merchant)
  end
end
