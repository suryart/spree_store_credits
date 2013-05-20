module Spree
  module Admin
    class StoreCreditReasonsController < Admin::ResourceController

      private
        def collection
          super.page(params[:page])
        end
    end
  end
end
