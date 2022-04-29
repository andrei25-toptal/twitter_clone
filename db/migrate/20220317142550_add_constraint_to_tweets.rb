class AddConstraintToTweets < ActiveRecord::Migration[7.0]
  def change
    change_table :tweets do |t|
      t.belongs_to :user, foreign_key: true, null: false
    end
  end
end
