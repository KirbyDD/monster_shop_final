require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  before :each do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @user_1 = @bike_shop.users.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy@hotmail.com", password: "test", role: 1)
    @twenty_perc = @bike_shop.discounts.create!(percentage: 20, quantity: 5)
    @ten_perc = @bike_shop.discounts.create!(percentage: 10, quantity: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end
  it 'should edit existing discounts' do
    visit '/merchant/discounts'

    within "#discount-#{@ten_perc.id}" do
      click_on "Delete Discount"
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Discount Deleted")
    @bike_shop.reload
    visit '/merchant/discounts'

    expect(page).to_not have_content("Discount Percentage: 10%")
    expect(page).to_not have_content("Item Quantity Needed: 2")
  end
end
