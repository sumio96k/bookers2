class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :favorited_books, through: :favorites, source: :book

  has_many :book_comments, dependent: :destroy

  # 自分がフォローする（与フォロー）側の関係性
  has_many :active_relationships, class_name: "Relationship",foreign_key: :follower_id, dependent: :destroy
  # 与フォロー関係を通じて参照→(has_many)自分がフォローしている人
  has_many :followings, through: :active_relationships, source: :followed
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :passive_relationships, class_name: "Relationship",foreign_key: :followed_id, dependent: :destroy
  # 被フォロー関係を通じて参照→(has_many)自分をフォローしている人
  has_many :followers, through: :passive_relationships, source: :follower

  #チャット
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms

  #閲覧数
  has_many :view_counts, dependent: :destroy

  has_one_attached :profile_image

  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }


  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.search_for(content,method)
    if method == "perfect"
      User.where(name: content)
    elsif method == "forward"
      User.where("name LIKE?", content + "%")
    elsif method == "backward"
      User.where("name LIKE?", "%" + content)
    elsif method == "partial"
      User.where("name LIKE?", "%" + content + "%")
    else
      User.all
    end
  end

  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'guestuser'
    end
  end


end


