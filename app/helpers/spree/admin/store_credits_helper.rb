module Spree
  module Admin
    module StoreCreditsHelper
      def link_to_show_user(user = nil)
        user.blank? ? "" : " for user: #{link_to user.email, [:admin, user]}".html_safe
      end
    end
  end
end