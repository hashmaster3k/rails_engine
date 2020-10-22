class ItemFacade
  def self.list_of_merchant_items(id)
    Merchant.find(id).items
  end

  def self.list_of_items_by_attribute(attribute, value)
    return items_by_name(value)        if attribute == "name"
    return items_by_description(value) if attribute == "description"
    return items_by_unit_price(value)  if attribute == "unit_price"
    return items_by_created_at(value)  if attribute == "created_at"
    return items_by_updated_at(value)  if attribute == "updated_at"
  end

  private

  def self.items_by_name(value)
    Item.where('name ILIKE ?', "%#{value.downcase}%")
  end

  def self.items_by_description(value)
    Item.where('description ILIKE ?', "%#{value.downcase}%")
  end

  def self.items_by_unit_price(value)
    Item.where(unit_price: value)
  end

  def self.items_by_created_at(value)
    date = Date.parse(value)
    Item.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  def self.items_by_updated_at(value)
    date = Date.parse(value)
    Item.where(updated_at: date.beginning_of_day..date.end_of_day)
  end
end
