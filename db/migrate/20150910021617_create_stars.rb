class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.integer :user_id
      t.date :date
      t.string :status

      t.timestamps null: false
    end
    add_index :stars, [:date, :user_id], unique: true
    add_index :stars, [:date, :status]
  end
end
