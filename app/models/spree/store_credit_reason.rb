class Spree::StoreCreditReason < ActiveRecord::Base
  attr_accessible :name

  validates :name, :uniqueness => true, :presence => true

  has_many :store_credits
  has_many :store_credit_types, :through => :store_credits
end
