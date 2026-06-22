class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  def subtotal_cents
    quantity * unit_price_cents
  end

  def subtotal_brl
    Product.format_brl(subtotal_cents)
  end

  def unit_price_brl
    Product.format_brl(unit_price_cents)
  end
end
