require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :quantity}
    it {should validate_inclusion_of(:percentage).in_range(1..100)}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end
end
