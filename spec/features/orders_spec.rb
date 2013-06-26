require 'spec_helper'

feature "Manage Orders" do
  background do
    @order = create(:order)
  end

  scenario 'Customer cancels order after Event deferral' do
    visit cancel_order_url(@order.uuid)
    expect(current_path).to eq root_path
  end
end