class User < ApplicationRecord
  validates :name, presence: trueus, length: {maximum: Settings.length.digit_10}
  validates :email, presence: true, length: {minimum: Settings.length.digit_20, maximum: Settings.length.digit_255},
    format: {with: Settings.VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false, scope: :group_id}
end
