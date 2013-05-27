# More on Spree's preference configuration - http://guides.spreecommerce.com/preferences.html#site_wide_preferences
module Spree
  class StoreCreditConfiguration < Preferences::Configuration
    preference :use_store_credit_minimum, :float, :default => 30.0
    preference :user_default_reason, :string, :default => "Store Credit"
    preference :unique_store_credits_per_user, :boolean, :default => false
    preference :store_credit_type_required, :boolean, :default => false
  end
end
