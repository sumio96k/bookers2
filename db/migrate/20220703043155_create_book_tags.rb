class CreateBookTags < ActiveRecord::Migration[6.1]
  def change
    create_table :book_tags do |t|
      t.integer :tag_id
      t.integer :book_id

      t.timestamps
    end
  end
end
