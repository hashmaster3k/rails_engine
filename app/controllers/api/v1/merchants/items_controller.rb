class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    return nil if !Merchant.is_merchant?(params[:id])
    items = ItemFacade.list_of_merchant_items(params[:id])
    render json: ItemSerializer.new(items)
  end
end
