class Api::V1::Items::MerchantsController < ApplicationController
  def show
    return nil if !Item.is_item?(params[:id])
    item = Item.find(params[:id])
    render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
  end
end
