require 'rails_helper'

RSpec.describe Revenue do
  it 'exits' do
    revenue = Revenue.new(29.5)
    expect(revenue).to be_a(Revenue)
    expect(revenue.id).to eq(nil)
    expect(revenue.revenue).to eq(29.5)
  end
end
