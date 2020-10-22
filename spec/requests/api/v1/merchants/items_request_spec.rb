require 'rails_helper'

RSpec.describe 'MERCHANT ITEMS API' do
  describe 'happy' do
    it 'returns all items for that merchant' do
      id_1 = create(:merchant).id
      id_2 = create(:merchant).id
      create(:item, merchant_id: id_1)
      create(:item, merchant_id: id_1)
      create(:item, merchant_id: id_2)
      create(:item, merchant_id: id_2)

      get "/api/v1/merchants/#{id_1}/items"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      items = json[:data]

      expect(items).to be_an(Array)
      expect(items.count).to eq(2)
    end
  end

  describe 'sad' do
    it 'returns a 204 if query entered wrong' do
      get "/api/v1/merchants/999/items"
      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
  end
end
