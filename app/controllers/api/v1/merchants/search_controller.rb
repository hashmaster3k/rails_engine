class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = MerchantFacade.list_of_merchants_by_attribute(params.keys.first, params[params.keys.first])
    return nil if merchants.empty?
    render json: MerchantSerializer.new(merchants)
  end

  def show
    if params[:created_at] || params[:updated_at]
      if params[:created_at]
        date = Date.parse(params[:created_at])
        merchant = Merchant.where(created_at: date.beginning_of_day..date.end_of_day).first
      else
        date = Date.parse(params[:updated_at])
        merchant = Merchant.where(updated_at: date.beginning_of_day..date.end_of_day).first
      end
      return nil if merchant == nil
      render json: MerchantSerializer.new(merchant)
    else #params[:name]
      merchant = Merchant.find_by('name ILIKE ?', "%#{params[:name].downcase}%")
      return nil if merchant == nil
      render json: MerchantSerializer.new(merchant)
    end
  end
end
