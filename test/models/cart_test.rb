require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = Cart.create!
    @keyboard = Product.create!(name: "Teclado", price_cents: 10_000)
    @mouse = Product.create!(name: "Mouse", price_cents: 5_000)
  end

  test "adicionar o mesmo produto incrementa a quantidade, não duplica" do
    @cart.add_product(@keyboard)
    @cart.add_product(@keyboard, quantity: 2)
    assert_equal 1, @cart.cart_items.count
    assert_equal 3, @cart.cart_items.first.quantity
  end

  test "total soma os subtotais de todos os itens" do
    @cart.add_product(@keyboard, quantity: 2) # 20.000
    @cart.add_product(@mouse)                  # 5.000
    assert_equal 25_000, @cart.total_cents
    assert_equal 3, @cart.total_items
  end

  test "carrinho recém-criado está vazio" do
    assert @cart.empty?
  end
end
