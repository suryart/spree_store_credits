module Spree
  class Admin::StoreCreditsController < Admin::ResourceController
    before_filter :load_store_credit_reasons_and_user, :only => [:new, :edit, :create, :update]
    before_filter :check_amounts, :only => [:edit, :update]
    prepend_before_filter :set_remaining_amount, :check_user, :only => [:create, :update]

    private
    def check_amounts
      if (@store_credit.remaining_amount < @store_credit.amount) and params[:reissue].nil?
        flash[:error] = I18n.t(:cannot_edit_used)
        redirect_to admin_store_credits_path
      else
        @reissue = true unless params[:reissue].nil?
      end
    end

    def set_remaining_amount
      params[:store_credit][:remaining_amount] = params[:store_credit][:amount]
    end

    def check_user
      user = load_user(params[:store_credit][:user_id], {:email => true})
      if user.nil?
        params[:store_credit][:user_id] = nil
      else
        params[:store_credit][:user_id] = user.id
      end
    end

    def collection
      super.page(params[:page])
    end

    def load_store_credit_reasons_and_user
      @store_credit_reasons = Spree::StoreCreditReason.all
      @store_credit_types = Spree::StoreCreditType.all
      @user = load_user(params[:user_id])
    end

    def load_user(user_id = nil, options = { :email => false })
      return nil if user_id.blank?
      column_type = options[:email] ? :email : :id
      if Spree.user_class
        user = Spree.user_class.to_s.constantize.where(column_type => user_id).first
      else
        user = Spree::User.where(column_type => user_id).first
      end
      user
    end
  end
end
