class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :users
  has_many :item_orders, through: :items
  has_many :discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: %w(active disabled)

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    orders = item_orders.where('item_orders.status = 0', 'items.merchant_id = ?', self.id).pluck(:order_id)
    Order.find(orders)
  end

  def change_status
    if status == "active"
      update(status: "disabled")
    else
      update(status: "active")
    end
  end

  def apply_discount(item, order_quantity)
    discount = discounts.where("quantity <= ?", order_quantity).order(percentage: :desc).pluck(:percentage).first
    if discount
      discount_amount = item.price * order_quantity * (discount.to_f / 100)
      item.price * order_quantity - discount_amount
    else
      item.price * order_quantity
    end
  end

end
