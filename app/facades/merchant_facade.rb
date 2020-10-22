class MerchantFacade
  def self.list_of_merchants_by_attribute(attribute, value)
    return merchants_by_name(value)        if attribute == "name"
    return merchants_by_created_at(value)  if attribute == "created_at"
    return merchants_by_updated_at(value)  if attribute == "updated_at"
  end

  private

  # multi-finders
  def self.merchants_by_name(value)
    Merchant.where('name ILIKE ?', "%#{value.downcase}%")
  end

  def self.merchants_by_created_at(value)
    date = Date.parse(value)
    Merchant.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  def self.merchants_by_updated_at(value)
    date = Date.parse(value)
    Merchant.where(updated_at: date.beginning_of_day..date.end_of_day)
  end
end
