class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def destroy_merchant_and_associations
    items.destroy_all
    self.destroy
  end

  def self.is_merchant?(id)
    find(id) rescue nil
  end

  def self.merchants_from_ids(ids)
    find(ids)
  end
end
