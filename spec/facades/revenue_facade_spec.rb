require 'rails_helper'

RSpec.describe 'Revenue Facade' do
  before :each do
    cus = create(:customer)
    mer1 = Merchant.create!(name: 'Billy')
    it1 = mer1.items.create!(name: 'Frisbee', description: 'woo', unit_price: 3.50)
    in1 = mer1.invoices.create!(customer_id: cus.id, status: 'shipped')
    ii1 = it1.invoice_items.create!(invoice_id: in1.id, quantity: 2, unit_price: it1.unit_price)
    it2 = mer1.items.create!(name: 'Ball', description: 'woo', unit_price: 2.75)
    tr1 = in1.transactions.create!(credit_card_number: '123', credit_card_expiration_date: '', result: 'success')
    mer2 = Merchant.create!(name: 'Bob')
    it3 = mer2.items.create!(name: 'Bottle', description: 'woo', unit_price: 9.23)
    it4 = mer2.items.create!(name: 'Container', description: 'woo', unit_price: 5.99)
    @mer3 = Merchant.create!(name: 'Joel')
    it5 = @mer3.items.create!(name: 'Sock', description: 'woo', unit_price: 5.55)
    in2 = @mer3.invoices.create!(customer_id: cus.id, status: 'shipped')
    ii2 = it5.invoice_items.create!(invoice_id: in2.id, quantity: 2, unit_price: it5.unit_price)
    tr2 = in2.transactions.create!(credit_card_number: '123', credit_card_expiration_date: '', result: 'success')
    it6 = @mer3.items.create!(name: 'Belt', description: 'woo', unit_price: 5.55)
  end

  it 'returns a merchant_revenue_based_query' do
    merchants = RevenueFacade.merchant_revenue_based_query('most_items', 1)
    expect(merchants).to be_an(Array)
    expect(merchants.count).to eq(1)
    expect(merchants.first).to be_a(Merchant)
  end

  it 'returns revenue_for_merchant(id)' do
    revenue = RevenueFacade.revenue_for_merchant(Merchant.last.id)
    expect(revenue).to be_a(Revenue)
    expect(revenue.id).to eq(nil)
    expect(revenue.revenue).to be_a(Float)
  end

  it 'returns revenue between dates' do
    start_date = Time.now.strftime("%Y-%m-%d")
    end_date = Time.now.strftime("%Y-%m-%d")
    revenue = RevenueFacade.revenue_between_dates(start_date, end_date)
    expect(revenue).to be_a(Revenue)
    expect(revenue.id).to eq(nil)
    expect(revenue.revenue).to be_a(Float)
  end
end
