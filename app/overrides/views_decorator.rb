Deface::Override.new(
  :virtual_path => "spree/admin/shared/_configuration_menu",
  :name => "store_credits_admin_configurations_menu",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :text => "<%= configurations_sidebar_menu_item t(:store_credits), admin_store_credits_url %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/shared/_configuration_menu",
  :name => "store_credit_reasons_admin_configurations_menu",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :text => "<%= configurations_sidebar_menu_item t(:store_credit_reasons), admin_store_credit_reasons_url %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/shared/_configuration_menu",
  :name => "store_credit_types_admin_configurations_menu",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :text => "<%= configurations_sidebar_menu_item t(:store_credit_types), admin_store_credit_types_url %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/users/show",
  :name => "show_user_store_credits",
  :insert_after => "p",
  :partial => "spree/admin/users/store_credits")

Deface::Override.new(
  :virtual_path => "spree/admin/users/index",
  :name => "store_credits_admin_users_index_row_actions",
  :insert_bottom => "[data-hook='admin_users_index_row_actions']",
  :text => "&nbsp;<%= link_to_with_icon('icon-gift', t(:add_store_credit), new_admin_user_store_credit_url(user), :no_text => true) %>")

Deface::Override.new(
  :virtual_path => "spree/checkout/_payment",
  :name => "store_credits_checkout_payment_step",
  :insert_after => "[data-hook='checkout_payment_step']",
  :partial => "spree/checkout/store_credits",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/users/show",
  :name => "store_credits_account_my_orders",
  :insert_after => "[data-hook='account_my_orders']",
  :partial => "spree/users/store_credits",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/general_settings/edit",
  :name => "admin_general_settings_edit_for_sc",
  :insert_before => "[data-hook='buttons']",
  :partial => "spree/admin/store_credits/limit",
  :disabled => true)
