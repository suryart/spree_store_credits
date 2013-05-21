class Spree::Promotion::Actions::GiveStoreCredit < Spree::PromotionAction
  preference :amount, :decimal, :default => 0.0
  preference :reason_id, :integer, :default => (Spree::StoreCreditReason.table_exists? ? Spree::StoreCreditReason.first.try(:id) : nil)
  preference :expiry_days, :integer, :default => 0
  attr_accessible :preferred_amount, :preferred_reason_id, :preferred_expiry_days

  def perform(options = {})
    expiry_days = preferred_expiry_days <= 0 ? nil : Time.zone.now+preferred_expiry_days.days
    if _user = options[:user]
      _user.store_credits.create(:amount => preferred_amount, :remaining_amount => preferred_amount,  :store_credit_reason_id => preferred_reason_id, :expiry => expiry_days)
    end
  end

end
