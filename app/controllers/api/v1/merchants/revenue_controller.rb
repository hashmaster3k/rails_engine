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
end
