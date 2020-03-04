require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  before :each do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @user_1 = @bike_shop.users.create!(name: "Tommy", address: "123", city: "Bruh", state: "CO", zip: "99999", email: "zboy@hotmail.com", password: "test", role: 1)
    @twenty_perc = @bike_shop.discounts.create!(percentage: 20, quantity: 5)
    @ten_perc = @bike_shop.discounts.create!(percentage: 10, quantity: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end
  it 'should create new discounts' do
    visit '/merchant/discounts'
    click_on "Create New Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    fill_in :percentage, with: 30
    fill_in :quantity, with: 10
    click_on "Create"

    expect(current_path).to eq('/merchant/discounts')
    expect(page).to have_content("Discount Created")
    expect(page).to have_content("Discount Percentage: 30%")
    expect(page).to have_content("Item Quantity Needed: 10")
  end

  it 'should not create item if percentage is over 100' do
    visit '/merchant/discounts'
    click_on "Create New Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    fill_in :percentage, with: 101
    fill_in :quantity, with: 10
    click_on "Create"

    expect(page).to have_content('Discount Not Created. Please try again.')
  end
end
