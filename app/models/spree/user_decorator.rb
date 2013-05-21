if Spree.user_class
  Spree.user_class.class_eval do
    has_many :store_credits, :class_name => "Spree::StoreCredit"

    def has_store_credit?
      store_credits.active.present?
    end

    # Should check for only default reason and not all
    # For example:
    # Credit total of store credits where reason name 
    # is 'Store Credit', 'Store Wallet', or 'My Credits'
    def store_credits_total
      reason = Spree::StoreCreditReason.find_or_create_by_name(Spree::Config[:user_default_reason])
      store_credits.active.where(:store_credit_reason_id => reason.id).sum(:remaining_amount)
    end
  end
end
