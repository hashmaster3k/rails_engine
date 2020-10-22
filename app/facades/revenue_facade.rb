class RevenueFacade
  def self.merchant_revenue_based_query(query, quantity)
    merchants = most_items_sold(quantity)            if query == "most_items"
    merchants = merchant_with_most_revenue(quantity) if query == "most_revenue"

    Merchant.merchants_from_ids(merchants.pluck('id'))
  end

  def self.revenue_for_merchant(id)
    ActiveRecord::Base.connection.execute("SELECT SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants m JOIN items i ON i.merchant_id = m.id JOIN invoice_items ii ON i.id = ii.item_id JOIN invoices v ON v.id = ii.invoice_id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' AND m.id = '#{id}';").first
  end

  private

  def self.most_items_sold(quantity)
    ActiveRecord::Base.connection.execute("SELECT m.id, SUM(ii.quantity) AS sold FROM merchants m JOIN invoices v ON m.id = v.merchant_id JOIN invoice_items ii ON ii.invoice_id = v.id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' GROUP BY m.id ORDER BY sold DESC LIMIT #{quantity};")
  end

  def self.merchant_with_most_revenue(quantity)
    ActiveRecord::Base.connection.execute("SELECT m.id, SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants m JOIN invoices v ON m.id = v.merchant_id JOIN invoice_items ii ON ii.invoice_id = v.id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' GROUP BY m.id ORDER BY revenue DESC LIMIT #{quantity};")
  end
end
