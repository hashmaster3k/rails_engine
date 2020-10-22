require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'instance methods' do
    it '#destroy_merchant_and_associations' do
      create(:item)
      expect(Merchant.count).to eq(1)
      expect(Item.count).to eq(1)
      Merchant.first.destroy_merchant_and_associations
      expect(Merchant.count).to eq(0)
      expect(Item.count).to eq(0)
    end

    describe 'class methods' do
      it '#is_merchant?' do
        expect(Merchant.is_merchant?(1)).to eq(nil)
      end

      it '#merchants_from_ids' do
        create_list(:merchant, 3)
        ids = [Merchant.first.id, Merchant.second.id, Merchant.third.id]
        merchants = Merchant.merchants_from_ids(ids)
        expect(merchants.count).to eq(3)
      end
    end
  end
end
