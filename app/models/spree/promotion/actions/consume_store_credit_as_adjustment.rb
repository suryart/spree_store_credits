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
        preference :reason_id, :integer, :default => (Spree::StoreCreditReason.table_exists? ? Spree::StoreCreditReason.first.try(:id) : nil)
        attr_accessible :preferred_amount, :preferred_reason_id

        # Creates the store credit adjustment from customer's active store credits 
        # related to a promotion/ store credit for the customer's order passed
        # through options hash
        def perform(options = {})
          order = options[:order]
          return if order.promotion_credit_exists?(self.promotion)

          self.create_adjustment(order) unless order.nil?
        end

        # Override of CalculatedAdjustments#create_adjustment so promotional
        # store credit adjustments are added from customer's 
        # verfied and valid store credits.
        def create_adjustment(order, mandatory=false)
          source = find_source(order)
          return if source.nil?
          amount = compute_amount(order)
          params = {  :amount => amount,
                      :label => source.name,
                      :source => source,                   
                      :originator => self,
                      :mandatory => mandatory }
          order.adjustments.create(params, :without_protection => true)
        end

        # Ensure a negative amount which does not exceed the sum of the order's
        # item_total and ship_total
        def compute_amount(calculable)
          store_credit = find_source(calculable)
          calc_amount = [(calculable.item_total + calculable.ship_total), super.to_f.abs].min
          remaining_amount =  store_credit.try(:remaining_amount)
          (remaining_amount.nil? ? calc_amount : [calc_amount, remaining_amount].min) * -1
        end

        def find_source(order)
          order.user.store_credits.active.detect{ |sc| sc.store_credit_reason_id == preferred_reason_id }
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
  