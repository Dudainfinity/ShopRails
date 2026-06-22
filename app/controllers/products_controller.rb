class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @products = Product.with_attached_image.order(:name)
  end

  def show
    @product = Product.with_attached_image.find(params[:id])
  end
end
