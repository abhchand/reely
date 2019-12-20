class CreateProductFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :product_feedbacks do |t|
      t.timestamps null: false
      t.references :user, foreign_key: true, index: true, null: false
      t.string :body, null: false
    end
  end
end
