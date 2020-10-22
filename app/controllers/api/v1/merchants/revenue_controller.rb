class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    return_quantity = params[:quantity].to_i
    return nil if return_quantity.to_i < 1
    query = request.env["PATH_INFO"].split('/').last
    merchants = RevenueFacade.merchant_revenue_based_query(query, return_quantity)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    return nil if !Merchant.is_merchant?(params[:id])
    result = RevenueFacade.revenue_for_merchant(params[:id])
    render json: {data: {id: "null", attributes: {revenue: result['revenue'].round(2)}}}
  end
end
