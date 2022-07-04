class Book < ApplicationRecord

  has_one_attached :image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  validates :rate, presence: true

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
    elsif method == "partial"
      Book.where("title LIKE?", "%" + content + "%")
    else
      Book.all
    end
  end

  

  def save_tag(sent_tags)
    #タグが存在していれば、タグの名前を配列としてすべて取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    #現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    #送信されてきたタグから現在存在するのタグを除いてnewtagとする
    new_tags = sent_tags - current_tags

    #古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tags.find_by(name: old)
    end

    #新しいタグを保存
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
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
