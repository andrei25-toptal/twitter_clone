class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.belongs_to :followed_user, null:false
      t.belongs_to :following_user, null: false
      t.timestamps
    end
  end
end
