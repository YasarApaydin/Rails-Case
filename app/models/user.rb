class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :lockable

  # Email format validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: "is invalid" }

  # Password validation
  validates :password,
            presence: true,
            length: { minimum: 8, message: "must be at least 8 characters" },
            format: { 
              with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/,
              message: "must include at least one lowercase, one uppercase, one number and one special character"
            },
            if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
