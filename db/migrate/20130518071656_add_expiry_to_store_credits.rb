class AddExpiryToStoreCredits < ActiveRecord::Migration
  def up
    unless column_exists?(:spree_store_credits, :expiry)
      add_column :spree_store_credits, :expiry, :datetime
    end
  end

  def down
    if column_exists?(:spree_store_credits, :expiry)
      remove_column :spree_store_credits, :expiry
    end
  end
end
