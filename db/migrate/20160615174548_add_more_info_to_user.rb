class AddMoreInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :last_name, :string
  	add_column :users, :phone, :string
  	add_column :users, :gender, :string
  	add_column :users, :birthdate, :date
  	add_column :users, :hometown, :string
  	add_column :users, :marital_status, :string
  	add_column :users, :about_me, :string
  	add_column :users, :profile_picture, :string
  	
  end
end
