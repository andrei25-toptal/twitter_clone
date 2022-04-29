class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.belongs_to :user, foreign_key: true, null:false
      t.belongs_to :tweet, foreign_key: true, null: false
      
      t.timestamps
    end
  end
end
