class CartItemsController < ApplicationController
  allow_unauthenticated_access only: %i[create update destroy]

  def create
    product = Product.find(params[:product_id])
    current_cart.add_product(product, quantity: quantity_param)
    redirect_back fallback_location: cart_path, notice: "#{product.name} adicionado ao carrinho."
  end

  def update
    item = current_cart.cart_items.find(params[:id])
    if quantity_param.positive?
      item.update(quantity: quantity_param)
    else
      item.destroy # quantidade 0 remove o item
    end
    redirect_to cart_path
  end

  def destroy
    current_cart.cart_items.find(params[:id]).destroy
    redirect_to cart_path, notice: "Item removido."
  end

  private

  def quantity_param
    params.fetch(:quantity, 1).to_i
  end
end
