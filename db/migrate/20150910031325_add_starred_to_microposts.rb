class AddStarredToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :starred, :boolean, default: false
  end
end
