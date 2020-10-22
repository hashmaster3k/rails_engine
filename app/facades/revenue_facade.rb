class RevenueFacade
  def self.merchant_revenue_based_query(query, quantity)
    merchants = most_items_sold(quantity)            if query == "most_items"
    merchants = merchant_with_most_revenue(quantity) if query == "most_revenue"

    Merchant.merchants_from_ids(merchants.pluck('id'))
  end

  def self.revenue_for_merchant(id)
    ActiveRecord::Base.connection.execute("SELECT SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants m JOIN items i ON i.merchant_id = m.id JOIN invoice_items ii ON i.id = ii.item_id JOIN invoices v ON v.id = ii.invoice_id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' AND m.id = '#{id}';").first
  end

  def self.revenue_between_dates(start_date, end_date)
    Invoice
      .joins(:invoice_items, :transactions)
      .where("transactions.result = 'success' AND invoices.status = 'shipped' AND invoices.created_at BETWEEN '#{start_date.to_date.beginning_of_day.to_s}' AND '#{end_date.to_date.end_of_day.to_s}'")
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  private

  def self.most_items_sold(quantity)
    Merchant
      .select("merchants.id, SUM(invoice_items.quantity)")
      .joins(:invoice_items, :transactions)
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .group("merchants.id")
      .order(Arel.sql("SUM(invoice_items.quantity) DESC"))
      .limit(quantity)
  end

  def self.merchant_with_most_revenue(quantity)
    Merchant
      .select("merchants.id, SUM(invoice_items.quantity * invoice_items.unit_price)")
      .joins(:invoice_items, :transactions)
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .group("merchants.id")
      .order(Arel.sql("SUM(invoice_items.quantity * invoice_items.unit_price) DESC"))
      .limit(quantity)
  end
end
