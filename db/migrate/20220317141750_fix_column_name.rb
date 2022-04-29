class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    change_table :tweets do |t|
      t.rename :tweet, :content
    end
  end
end
