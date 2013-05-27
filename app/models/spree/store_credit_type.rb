class Spree::StoreCreditType < ActiveRecord::Base
  attr_accessible :name

  validates :name, :uniqueness => true, :presence => true
  
  has_many :store_credits
  has_many :store_credit_reasons, :through => :store_credits
end
