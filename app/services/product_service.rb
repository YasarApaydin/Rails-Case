
class ProductService
  attr_reader :errors

  def initialize
    @errors = []
  end

  # Yeni ürün oluşturma
  def create(params)
    product = Product.new(params)

    if product.save
      product
    else
      @errors = product.errors.full_messages
      product # her zaman Product objesi döndür
    end
  end

  # Ürün güncelleme
  def update(product, params)
    if product.update(params)
      product
    else
      @errors = product.errors.full_messages
      product
    end
  end

  # Ürün silme
  def destroy(product)
    product.soft_delete
  end
end
