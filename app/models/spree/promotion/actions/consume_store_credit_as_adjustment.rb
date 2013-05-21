module Spree
  class Promotion
    module Actions
      # Consume customer's store credit if its active and available.
      # Responsible for the creation and management of an store credit adjustment since an
      # an adjustment uses its originator to also update its eligiblity and amount
      class ConsumeStoreCreditAsAdjustment < PromotionAction
        calculated_adjustments

        has_many :adjustments, :as => :originator

        delegate :eligible?, :to => :promotion

        before_validation :ensure_action_has_calculator
        before_destroy :deals_with_adjustments

        preference :amount, :decimal, :default => 0.0
        preference :reason_id, :integer, :default => Spree::StoreCreditReason.first.id
        attr_accessible :preferred_amount, :preferred_reason_id

        # Creates the store credit adjustment from customer's active store credits 
        # related to a promotion/ store credit for the customer's order passed
        # through options hash
        def perform(options = {})
          order = options[:order]
          return if order.promotion_credit_exists?(self.promotion)
          label = Spree::StoreCreditReason.find(preferred_reason_id).name

          if _user = options[:user]
            store_credit = _user.store_credits.active.detect{ |sc| sc.store_credit_reason_id == preferred_reason_id }
            self.create_adjustment(order, order, store_credit) unless store_credit.nil?
          end
        end

        # Override of CalculatedAdjustments#create_adjustment so promotional
        # store credit adjustments are added from customer's 
        # verfied and valid store credits.
        def create_adjustment(target, calculable, source, mandatory=false)
          amount = compute_amount(calculable)
          params = { :amount => amount,
                    :source => source,
                    :originator => self,
                    :label => source.name,
                    :mandatory => mandatory }
          target.adjustments.create(params, :without_protection => true)
        end

        # Ensure a negative amount which does not exceed the sum of the order's
        # item_total and ship_total
        def compute_amount(calculable)
          [(calculable.item_total + calculable.ship_total), super.to_f.abs].min * -1
        end

        private
          def ensure_action_has_calculator
            return if self.calculator
            self.calculator = Calculator::FlatPercentItemTotal.new
          end

          def deals_with_adjustments
            self.adjustments.each do |adjustment|
              if adjustment.adjustable.complete?
                adjustment.originator = nil
                adjustment.save
              else
                adjustment.destroy
              end
            end
          end
      end
    end
  end
end
  