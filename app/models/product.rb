class Product < ApplicationRecord
  include Auditable   

  
  validates :name, presence: true, length: { minimum: 3, message: "must be at least 3 characters" }
  validates :price, presence: true, numericality: { greater_than: 0, message: "must be greater than 0" }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: "must be at least 1" }
  validates :category, presence: true, length: { minimum: 3, message: "must be at least 3 characters" }

  

  def soft_delete
    update!(
      is_deleted: true,
      deleted_at: Time.current
    )
  end
end
