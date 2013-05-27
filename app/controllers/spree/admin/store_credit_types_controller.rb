module Spree
  module Admin
    class StoreCreditTypesController < Admin::ResourceController

      private
        def collection
          super.page(params[:page])
        end
    end
  end
end