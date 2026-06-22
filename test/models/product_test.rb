require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "exige nome" do
    assert_not Product.new(name: nil, price_cents: 100).valid?
  end

  test "preço em reais é derivado dos centavos" do
    assert_in_delta 349.0, Product.new(price_cents: 34_900).price, 0.001
  end

  test "formata preço em BRL" do
    assert_equal "R$ 349,00", Product.new(price_cents: 34_900).price_brl
  end

  test "não aceita preço negativo" do
    assert_not Product.new(name: "X", price_cents: -1).valid?
  end
end
