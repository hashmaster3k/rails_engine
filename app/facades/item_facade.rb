class ItemFacade
  def self.list_of_merchant_items(id)
    serialize_data(Merchant.find(id).items)
  end

  private

  def self.serialize_data(data)
    ItemSerializer.new(data)
  end
end
