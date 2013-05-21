module Spree
  class Promotion
    module Rules
      class UserHasStoreCredit < PromotionRule
        # has_and_belongs_to_many :store_credit_reasons, :class_name => '::Spree::StoreCreditReason', :join_table => 'spree_products_promotion_rules', :foreign_key => 'promotion_rule_id'
        # validate :only_one_promotion_per_store_credit

        preference :reason_id, :integer, :default => (Spree::StoreCreditReason.table_exists? ? Spree::StoreCreditReason.first.try(:id) : nil)

        attr_accessible :preferred_reason_id #, :preferred_operator

        def eligible?(order, options = {})
          user = order.try(:user) || options[:user]
          return false if user.nil?

          !user.store_credits.active.detect{ |sc| sc.store_credit_reason_id == preferred_reason_id }.nil?
        end

        # private

        #   def only_one_promotion_per_store_credit
        #     if Spree::Promotion::Rules::StoreCreditReason.all.map(&:store_credit_reasons).flatten.uniq!
        #       errors[:base] << "You can't create two promotions for the same product"
        #     end
        #   end
      end
    end
  end
end