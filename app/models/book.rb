class Book < ApplicationRecord

  has_one_attached :image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content,method)
    if method == "perfect"
      Book.where(title: content)
    elsif method == "forward"
      Book.where("title LIKE ?", content + "%")
    elsif method == "backward"
      Book.where("title LIKE ?", "%" + content)
    elsif method == "patial"
      Book.where("name LIKE?", "%" + content + "%")
    else
      Book.all
    end
  end

  def self.orders(method)
    if method == "new"
      Book.order(created_at: :DESC)
    elsif method == "high_rate"
      Book.order(rate: :DESC)
    end
  end


end
