class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    return_quantity = params[:quantity].to_i
    return nil if return_quantity.to_i < 1
    query = request.env["PATH_INFO"].split('/').last
    merchants = RevenueFacade.merchant_revenue_based_query(query, return_quantity)
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
