class CreateSpreeStoreCreditReasons < ActiveRecord::Migration
  def change
    create_table :spree_store_credit_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
