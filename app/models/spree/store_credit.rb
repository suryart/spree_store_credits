class Spree::StoreCredit < ActiveRecord::Base
  attr_accessible :user_id, :amount, :store_credit_reason_id, :remaining_amount, :expiry

  validates :amount, :remaining_amount, :presence => true, :numericality => true
  validates :user, :store_credit_reason, :presence => true
  validate :amounts, :expiry_date

  belongs_to :store_credit_reason

  delegate :name, :to => :store_credit_reason, :prefix => false
  delegate :email, :to => :user, :prefix => false

  scope :active, lambda { where("(expiry IS NULL OR expiry >= :expiry) AND remaining_amount > :amount", { :expiry => Time.zone.now, :amount => 0 }) }

  if Spree.user_class
    belongs_to :user, :class_name => Spree.user_class.to_s
  else
    belongs_to :user
    attr_accessible :amount, :store_credit_reason_id, :remaining_amount, :user_id, :expiry
  end

  private
    # Remaning amount can never be more than the amount given to user.
    def amounts
      errors.add(:remaining_amount, I18n.t(:invalid_remaning_amount)) if self.remaining_amount > self.amount
    end

    # Validate only when there is an expiry date. For the check for nil.
    # If expiry is set to nil, then that credit will never expire.
    def expiry_date
      unless self.expiry.nil?
        errors.add(:expiry, I18n.t(:invalid_expiry)) if self.expiry <= Time.zone.now
      end
    end
end
