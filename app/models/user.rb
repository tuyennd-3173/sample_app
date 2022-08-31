class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.length.digit_10}
  validates :email, presence: true,
            length: {
              minimum: Settings.length.digit_20,
              maximum: Settings.length.digit_255
            },
            format: {with: Settings.VALID_EMAIL_REGEX}
  validates :password, presence: true,
    length: {minimum: Settings.length.digit_6}, if: :password
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
