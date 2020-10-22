class Api::V1::RevenueController < ApplicationController
  def index
    return nil if !(valid_date?(params[:start]) && valid_date?(params[:end]))
    result = RevenueFacade.revenue_between_dates(params[:start], params[:end])
    render json: {data: {id: "null", attributes: {revenue: result.round(2)}}}
  end
end
