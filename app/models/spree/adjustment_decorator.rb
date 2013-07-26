Spree::Adjustment.class_eval do
  scope :store_credits, lambda { where(:source_type => 'Spree::StoreCredit') }

  # Allow originator of the adjustment to perform an additional eligibility of the adjustment
  # Should return _true_ if originator is absent or doesn't implement _eligible?_
  # eligible check should be run against adjustable not the source
  # as source is for locating the origin of adjustment while adjustable
  # should be checked for eligibility on an originator
  def eligible_for_originator?
    return true if originator.nil?
    !originator.respond_to?(:eligible?) || originator.eligible?(adjustable)
  end
end