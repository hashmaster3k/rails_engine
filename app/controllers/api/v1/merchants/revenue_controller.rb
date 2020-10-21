class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    return nil if params[:quantity].to_i < 1

    if request.env["PATH_INFO"].split('/').last == "most_items"
      result = ActiveRecord::Base.connection.execute("SELECT m.id, SUM(ii.quantity) AS sold FROM merchants m JOIN invoices v ON m.id = v.merchant_id JOIN invoice_items ii ON ii.invoice_id = v.id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' GROUP BY m.id ORDER BY sold DESC LIMIT #{params[:quantity]};")
    else #most_revenue
      result = ActiveRecord::Base.connection.execute("SELECT m.id, SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants m JOIN invoices v ON m.id = v.merchant_id JOIN invoice_items ii ON ii.invoice_id = v.id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' GROUP BY m.id ORDER BY revenue DESC LIMIT #{params[:quantity]};")
    end

    merchants = result.pluck("id").map do |id|
      Merchant.find(id)
    end

    render json: MerchantSerializer.new(merchants)
  end

  def show
    begin
      Merchant.find(params[:id])
    rescue
      return nil
    end
    merchant = Merchant.find(params[:id])
    result = ActiveRecord::Base.connection.execute("SELECT SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants m JOIN items i ON i.merchant_id = m.id JOIN invoice_items ii ON i.id = ii.item_id JOIN invoices v ON v.id = ii.invoice_id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' AND m.id = '#{merchant.id}';").first

    render json: {data: {id: "null", attributes: {revenue: result["revenue"].round(2)}}}
  end
end
