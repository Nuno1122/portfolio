class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true , type: :uuid
      t.text :content, null: false
			t.timestamps
    end
  end
end
