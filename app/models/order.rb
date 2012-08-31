class Order < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :line_items, dependent: :destroy
  validates :name, :email, presence: :true

  attr_accessor :stripe_card_token

  def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def save_with_payment
    if valid?

    end
  end
end
