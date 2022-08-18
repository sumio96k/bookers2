class Category < ActiveHash::Base
  self.data = [
    { id: 0, name: '---'},
    { id: 1, name: 'ビジネス書'},
    { id: 2, name: '小説'},
    { id: 3, name: '漫画'},
    ]
  include ActiveHash::Associations
  has_many :books
end