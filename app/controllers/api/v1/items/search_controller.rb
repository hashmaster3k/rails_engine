class Api::V1::Items::SearchController < ApplicationController
  def index
    attribute = params.keys.first
    value = params[params.keys.first]
    items = ItemFacade.list_of_items_by_attribute(attribute, value)
    return nil if items.empty?
    render json: ItemSerializer.new(items)
  end

  def show
    if params[:description]
      item = Item.find_by('description ILIKE ?', "%#{params[:description].downcase}%")
    elsif params[:unit_price]
      item = Item.find_by(unit_price: params[:unit_price])
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      item = Item.where(created_at: date.beginning_of_day..date.end_of_day).first
    elsif params[:updated_at]
      date = Date.parse(params[:updated_at])
      item = Item.where(updated_at: date.beginning_of_day..date.end_of_day).first
    else #params[:name]
      item = Item.find_by('name ILIKE ?', "%#{params[:name].downcase}%")
    end

    return nil if item == nil
    render json: ItemSerializer.new(item)
  end
end
