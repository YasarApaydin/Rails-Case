
class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show edit update destroy hard_delete]


  def index
    @products = Product.active
  end

  def new
    @product = Product.new
  end
  def hard_delete
    Product.unscoped.find(params[:id]).destroy!
    redirect_to products_path, notice: "Product permanently deleted"
  end

  def create
    service = ProductService.new
    @product = service.create(product_params)

    if @product.errors.any?
      flash.now[:alert] = service.errors.join(", ")
      render :new, status: :unprocessable_entity
    else
      redirect_to products_path, notice: "Product created successfully"
    end
  end

  def edit
  end

  def update
    service = ProductService.new
    @product = service.update(@product, product_params)

    if @product.errors.any?
      flash.now[:alert] = service.errors.join(", ")
      render :edit, status: :unprocessable_entity
    else
      redirect_to products_path, notice: "Product updated successfully"
    end
  end

  def destroy
    ProductService.new.destroy(@product)
    redirect_to products_path, notice: "Product deleted successfully"
  end

  private

  def set_product
    @product = Product.unscoped.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :stock, :category)
  end
end
