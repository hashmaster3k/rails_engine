class Api::V1::Items::SearchController < ApplicationController
  def index
    items = ItemFacade.list_of_items_by_attribute(params.keys.first, params[params.keys.first])
    return nil if items.empty?
    render json: ItemSerializer.new(items)
  end

  def show
    item = ItemFacade.first_item_by_attribute(params.keys.first, params[params.keys.first])
    return nil if item == nil
    render json: ItemSerializer.new(item)
  end
end
