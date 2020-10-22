class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = MerchantFacade.list_of_merchants_by_attribute(params.keys.first, params[params.keys.first])
    return nil if merchants.empty?
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = MerchantFacade.first_merchant_by_attribute(params.keys.first, params[params.keys.first])
    return nil if merchant == nil
    render json: MerchantSerializer.new(merchant)
  end
end
