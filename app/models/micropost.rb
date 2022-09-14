class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true,
            length: {maximum: Settings.length.digit_140}
  validates :image,
            content_type: {
              in: Settings.image.format,
              message: I18n.t(".valid_image")
            },
            size: {
              less_than: Settings.image.size_5.megabytes,
              message: I18n.t(".size_image")
            }

  scope :newest, ->{order created_at: :desc}

  delegate :name, to: :user

  def display_image
    image.variant resize_to_limit: Settings.image.range_500
  end
end
