class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  def subtotal_cents
    quantity * product.price_cents
  end

  def subtotal_brl
    Product.format_brl(subtotal_cents)
  end
end
