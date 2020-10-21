class Api::V1::RevenueController < ApplicationController
  def index
    begin
      params[:start].to_date
      params[:end].to_date
    rescue
      return nil
    end
    
    result = ActiveRecord::Base.connection.execute("SELECT SUM(ii.quantity * ii.unit_price) AS revenue FROM invoices v JOIN invoice_items ii ON ii.invoice_id = v.id JOIN transactions t ON t.invoice_id = v.id WHERE t.result = 'success' AND v.status = 'shipped' AND v.created_at BETWEEN '#{params[:start].to_date.beginning_of_day.to_s}' AND '#{params[:end].to_date.end_of_day.to_s}';").first

    render json: {data: {id: "null", attributes: {revenue: result["revenue"].round(2)}}}
  end
end
