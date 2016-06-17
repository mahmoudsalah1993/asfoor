class AddPrivateToPosts < ActiveRecord::Migration
  def change
  	add_column :microposts, :is_private, :boolean, :default => false 
  end
end
