Spree::AppConfiguration.class_eval do
  preference :use_store_credit_minimum, :float, :default => 30.0
  preference :user_default_reason, :string, :default => "Store Credit"
  preference :unique_store_credits_per_user, :boolean, :default => false
end
