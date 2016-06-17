class CreateFriendsRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :requester_id
      t.integer :requested_id
      t.timestamps null: false
    end
    add_index :requests, :requester_id
    add_index :requests, :requested_id
    add_index :requests, [:requester_id, :requested_id], unique: true
  end
end
