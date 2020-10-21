require 'rails_helper'

RSpec.describe 'MERCHANT REVENUE API' do
  describe 'merchants with most revenue' do
    describe 'happy' do
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

      it 'returns a list of merchants with highest revenue' do
        num_of_merchants = 3
        get "/api/v1/merchants/most_revenue?quantity=#{num_of_merchants}"
        expect(response).to be_successful
        json = JSON(response.body, symbolize_names: true)
        expect(json[:data]).to be_a(Array)
        expect(json[:data].count).to eq(2)
        expect(json[:data].first[:id].to_i).to eq(@mer3.id)
      end
    end

    describe 'sad' do
      it 'returns a 204 if query entered wrong' do
        get '/api/v1/merchants/most_revenue?name=blonde'
        expect(response).to be_successful
        expect(response.status).to eq(204)
      end
    end
  end

  describe 'merchants with most items sold' do
    describe 'happy' do
      before :each do
        cus = create(:customer)
        @mer1 = Merchant.create!(name: 'Billy')
        it1 = @mer1.items.create!(name: 'Frisbee', description: 'woo', unit_price: 3.50)
        in1 = @mer1.invoices.create!(customer_id: cus.id, status: 'shipped')
        ii1 = it1.invoice_items.create!(invoice_id: in1.id, quantity: 5, unit_price: it1.unit_price)
        it2 = @mer1.items.create!(name: 'Ball', description: 'woo', unit_price: 2.75)
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

      it 'returns list of ranked merchants with most items sold' do
        num_of_merchants = 3
        get "/api/v1/merchants/most_items?quantity=#{num_of_merchants}"
        expect(response).to be_successful
        json = JSON(response.body, symbolize_names: true)
        expect(json[:data]).to be_a(Array)
        expect(json[:data].count).to eq(2)
        expect(json[:data].first[:id].to_i).to eq(@mer1.id)
      end
    end

    describe 'sad' do
      it 'returns a 204 if query entered wrong' do
        get '/api/v1/merchants/most_revenue?name=3.2'
        expect(response).to be_successful
        expect(response.status).to eq(204)
      end
    end
  end
end
