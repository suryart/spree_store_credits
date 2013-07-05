class RemoveReasonFromStoreCredits < ActiveRecord::Migration
  def up
    # Before removing reason column from Spree::StoreCredit
    # add its value to Spree::StoreCreditReason -> name
    unless column_exists?(:spree_store_credits, :store_credit_reason_id)
      add_column :spree_store_credits, :store_credit_reason_id, :integer
    end
    puts "==  Adding Reasons to Spree::StoreCreditReason, this might take some time ===="
    puts "==  depening upon the number of rows available in Spree::StoreCredit table ==="
    all_store_credits = Spree::StoreCredit.all
    all_store_credit_reasons = []
    all_store_credits.uniq_by(&:reason).each { |sc| 
      all_store_credit_reasons << Spree::StoreCreditReason.find_or_create_by_name(sc.reason) 
    }
    all_store_credits.each{ |sc| 
      store_credit_reason = all_store_credit_reasons.detect{|scr| scr.name == sc.reason }
      sc.update_attribute(:store_credit_reason_id, store_credit_reason.id) unless store_credit_reason.nil?
    }
    if column_exists?(:spree_store_credits, :reason)
      remove_column :spree_store_credits, :reason
    end
  end

  def down
    unless column_exists?(:spree_store_credits, :reason)
      add_column :spree_store_credits, :reason, :string
    end

    # After adding reason column from Spree::StoreCredit
    # add its value back from Spree::StoreCreditReason -> name
    # and destroy the data from Spree::StoreCreditReason
    all_store_credit_reasons = Spree::StoreCreditReason.includes(:store_credits).all
    all_store_credit_reasons.each{ |scr| 
      scr.store_credits.each{ |sc| sc.update_attribute(:reason, scr.name) }
    }
    Spree::StoreCreditReason.destroy_all

    if column_exists?(:spree_store_credits, :store_credit_reason_id)
      remove_column :spree_store_credits, :store_credit_reason_id
    end
  end
end
