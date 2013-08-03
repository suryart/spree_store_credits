module Spree
  module Core
    CalculatedAdjustments.module_eval do

      # Calculate the amount to be used when creating an adjustment
      def compute_amount(calculable)
        if self.respond_to?(:originator)
          self.originator.respond_to?(:compute_amount) ? self.originator.compute_amount(calculable) : self.calculator.compute(calculable)
        else
          self.calculator.compute(calculable)
        end
      end
    end
  end
end