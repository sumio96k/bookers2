class Room < ApplicationRecord
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy

  validates :message, presence: true, length: { maximum: 140 }
end
