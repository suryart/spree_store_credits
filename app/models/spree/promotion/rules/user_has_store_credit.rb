module Spree
  class Promotion
    module Rules
      class UserHasStoreCredit < PromotionRule
        preference :reason_id, :integer, :default => (Spree::StoreCreditReason.table_exists? ? Spree::StoreCreditReason.first.try(:id) : nil)

        attr_accessible :preferred_reason_id #, :preferred_operator

        def eligible?(order, options = {})
          user = order.try(:user) || options[:user]
          return false if user.nil?

          !user.store_credits.active.detect{ |sc| sc.store_credit_reason_id == preferred_reason_id }.nil?
        end
      end
    end
  end
end