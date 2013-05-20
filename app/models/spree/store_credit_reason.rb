class Spree::StoreCreditReason < ActiveRecord::Base
  attr_accessible :name

  validates :name, :uniqueness => true, :presence => true

  has_many :store_credits
end
