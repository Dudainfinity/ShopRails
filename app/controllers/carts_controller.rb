class CartsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob })
  end
end
