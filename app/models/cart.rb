class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Adiciona um produto ao carrinho ou incrementa a quantidade se já existir.
  def add_product(product, quantity: 1)
    item = cart_items.find_or_initialize_by(product: product)
    # Item novo nasce com o default 1 da coluna; partimos de 0 para somar só o delta.
    base = item.persisted? ? item.quantity : 0
    item.quantity = base + quantity
    item.save
    item
  end

  def total_cents
    cart_items.includes(:product).sum { |item| item.subtotal_cents }
  end

  def total_brl
    Product.format_brl(total_cents)
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end
end
