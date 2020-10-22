require 'rails_helper'

RSpec.describe 'Item Facade' do
  it '#list_of_items_for_merchant()' do
    id = create(:merchant).id
    create(:item, merchant_id: id)
    create(:item, merchant_id: id)
    items = ItemFacade.list_of_items_for_merchant(id)
    expect(items.count).to eq(2)
  end

  it '#list_of_items_by_attribute()' do
    create_list(:item, 3)
    items = ItemFacade.list_of_items_by_attribute('name', 'ring')
    expect(items.count).to eq(3)
    items = ItemFacade.list_of_items_by_attribute('description', 'ring')
    expect(items.count).to eq(3)
    items = ItemFacade.list_of_items_by_attribute('unit_price', '1.5')
    expect(items.count).to eq(3)
    items = ItemFacade.list_of_items_by_attribute('updated_at', Date.today.to_s)
    expect(items.count).to eq(3)
    items = ItemFacade.list_of_items_by_attribute('created_at', Date.today.to_s)
    expect(items.count).to eq(3)
  end

  it '#first_item_by_attribute()' do
    create_list(:item, 3)
    item = ItemFacade.first_item_by_attribute('name', 'ring')
    expect(item).to be_a(Item)
    item = ItemFacade.first_item_by_attribute('description', 'ring')
    expect(item).to be_a(Item)
    item = ItemFacade.first_item_by_attribute('unit_price', '1.5')
    expect(item).to be_a(Item)
    item = ItemFacade.first_item_by_attribute('updated_at', Date.today.to_s)
    expect(item).to be_a(Item)
    item = ItemFacade.first_item_by_attribute('created_at', Date.today.to_s)
    expect(item).to be_a(Item)
  end
end
