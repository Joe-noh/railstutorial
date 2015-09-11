class AddRandomToUser < ActiveRecord::Migration
  def change
    add_column :users, :random, :float

    add_index :users, [:activated, :random]

    User.all.each do |user|
      user.update_attribute(:random, Random.rand)
    end
  end
end
