class AddStateToFriendship < ActiveRecord::Migration
  def change
    remove_column :friendships, :approved
    add_column :friendships, :state, :string
    add_index :friendships, :state
  end
end
