class AddTwitterIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :twitter_id, :string, unique: true
    add_column :users, :introduction, :string
    add_column :users, :image_url, :string
  end
end