class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    return nil if !Merchant.is_merchant?(params[:id])
    render json: ItemFacade.list_of_merchant_items(params[:id])
  end
end
