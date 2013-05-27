class CreateSpreeStoreCreditTypes < ActiveRecord::Migration
  def up
    create_table :spree_store_credit_types do |t|
      t.string :name

      t.timestamps
    end

    unless column_exists?(:spree_store_credits, :store_credit_type_id)
      add_column :spree_store_credits, :store_credit_type_id, :integer
    end
  end

  def down
    if column_exists?(:spree_store_credits, :store_credit_type_id)
      remove_column :spree_store_credits, :store_credit_type_id
    end

    drop_table :spree_store_credit_types
  end
end
