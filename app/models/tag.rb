class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :book_tags

  def self.search_for(content,method)
    if method == "perfect"
      Tag.where(name: content)
    elsif method == "forward"
      Tag.where("title LIKE ?", content + "%")
    elsif method == "backward"
      Tag.where("title LIKE ?", "%" + content)
    elsif method == "partial"
      Tag.where("title LIKE?", "%" + content + "%")
    else
      Tag.all
    end
  end

  def self.tag_search_for(content)
    Tag.where(tag_id[name: content])
  end

end
