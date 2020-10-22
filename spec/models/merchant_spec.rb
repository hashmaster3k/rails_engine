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

  describe 'instance_methods' do
    it '#destroy_merchant_and_associations' do
      create(:item)
      expect(Merchant.count).to eq(1)
      expect(Item.count).to eq(1)
      Merchant.first.destroy_merchant_and_associations
      expect(Merchant.count).to eq(0)
      expect(Item.count).to eq(0)
    end

    it '#is_merchant?' do
      expect(Merchant.is_merchant?(1)).to eq(nil)
    end
  end
end
