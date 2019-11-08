;;; pcomplete-declare-magento.el --- Magento completions  -*- lexical-binding: t; -*-

;; Copyright (C) 2019

;; Author:  <>
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'pcomplete-declare)

(eval-and-compile
  (defvar pcomplete-declare-magento-subcommands
    (list "help" "list" "admin:user:create" "admin:user:unlock"
          "app:config:dump" "app:config:import" "app:config:status"
          "cache:clean" "cache:disable" "cache:enable" "cache:flush"
          "cache:status" "catalog:images:resize"
          "catalog:product:attributes:cleanup" "config:sensitive:set"
          "config:set" "config:show" "cron:install" "cron:remove" "cron:run"
          "customer:hash:upgrade" "deploy:mode:set" "deploy:mode:show"
          "dev:di:info" "dev:profiler:disable" "dev:profiler:enable"
          "dev:query-log:disable" "dev:query-log:enable"
          "dev:source-theme:deploy" "dev:template-hints:disable"
          "dev:template-hints:enable" "dev:tests:run" "dev:urn-catalog:generate"
          "dev:xml:convert" "encryption:payment-data:update"
          "i18n:collect-phrases" "i18n:pack" "i18n:uninstall" "indexer:info"
          "indexer:reindex" "indexer:reset" "indexer:set-dimensions-mode"
          "indexer:set-mode" "indexer:show-dimensions-mode" "indexer:show-mode"
          "indexer:status" "info:adminuri" "info:backups:list"
          "info:currency:list" "info:dependencies:show-framework"
          "info:dependencies:show-modules"
          "info:dependencies:show-modules-circular" "info:language:list"
          "info:timezone:list" "maintenance:allow-ips" "maintenance:disable"
          "maintenance:enable" "maintenance:status" "module:disable"
          "module:enable" "module:status" "module:uninstall"
          "msp:security:recaptcha:disable" "msp:security:tfa:disable"
          "msp:security:tfa:providers" "msp:security:tfa:reset"
          "newrelic:create:deploy-marker" "queue:consumers:list"
          "queue:consumers:start" "sampledata:deploy" "sampledata:remove"
          "sampledata:reset" "setup:backup" "setup:config:set" "setup:cron:run"
          "setup:db-data:upgrade" "setup:db-declaration:generate-patch"
          "setup:db-declaration:generate-whitelist" "setup:db-schema:upgrade"
          "setup:db:status" "setup:di:compile" "setup:install"
          "setup:performance:generate-fixtures" "setup:rollback"
          "setup:static-content:deploy" "setup:store-config:set"
          "setup:uninstall" "setup:upgrade" "store:list" "store:website:list"
          "theme:uninstall" "varnish:vcl:generate"))

  (defvar pcomplete-declare-magento-cache-types
    (list "config" "layout" "block_html" "collections" "reflection" "db_ddl"
          "compiled_config" "eav" "customer_notification" "config_integration"
          "config_integration_api" "full_page" "config_webservice" "translate"
          "vertex"))

  (defun pcomplete-declare-magento-namespaces ()
    "Return subcommand namespaces."
    (loop for elm in pcomplete-declare-magento-subcommands
          for match = (string-match-p ":[^:]+\\'" elm)
          for seq = (if match (split-string (substring elm 0 match) ":"))
          nconc (loop for i from 1 to (length seq)
                      collect (string-join (seq-subseq seq 0 i) ":"))
          into result
          finally return (cl-delete-duplicates result :test #'string-equal)))

  (defvar pcomplete-declare-magento-config-options
    (list "web/seo/use_rewrites" "web/unsecure/base_url"
          "web/unsecure/base_static_url" "web/unsecure/base_media_url"
          "web/unsecure/base_link_url" "web/secure/base_url"
          "web/secure/use_in_frontend" "web/secure/use_in_adminhtml"
          "web/secure/base_static_url" "web/secure/base_media_url"
          "web/secure/enable_hsts" "web/secure/enable_upgrade_insecure"
          "web/secure/base_link_url" "web/default/cms_home_page"
          "web/default/cms_no_route" "web/default/front"
          "web/cookie/cookie_path" "web/cookie/cookie_domain"
          "web/cookie/cookie_httponly" "web/url/use_store"
          "web/default_layouts/default_product_layout"
          "web/default_layouts/default_category_layout"
          "web/default_layouts/default_cms_layout" "general/locale/code"
          "general/locale/timezone" "general/locale/weight_unit"
          "general/locale/firstday" "general/region/display_all"
          "general/region/state_required" "general/country/default"
          "general/country/destinations" "general/store_information/name"
          "general/store_information/phone" "general/store_information/hours"
          "general/store_information/country_id"
          "general/store_information/region_id"
          "general/store_information/postcode" "general/store_information/city"
          "general/store_information/street_line1"
          "general/store_information/street_line2"
          "general/store_information/merchant_vat_number"
          "general/single_store_mode/enabled" "currency/options/base"
          "currency/options/default" "currency/options/allow"
          "currency/yahoofinance/timeout" "currency/fixerio/timeout"
          "currency/import/service" "currency/import/time"
          "currency/import/frequency" "currency/import/error_email"
          "catalog/category/root_id" "catalog/frontend/list_allow_all"
          "catalog/frontend/flat_catalog_product" "catalog/frontend/list_mode"
          "catalog/frontend/grid_per_page_values"
          "catalog/frontend/grid_per_page"
          "catalog/frontend/flat_catalog_category"
          "catalog/productalert_cron/frequency" "catalog/productalert_cron/time"
          "catalog/productalert_cron/error_email"
          "catalog/product_video/youtube_api_key" "catalog/price/scope"
          "catalog/downloadable/shareable"
          "catalog/downloadable/content_disposition"
          "catalog/custom_options/use_calendar"
          "catalog/custom_options/year_range" "catalog/placeholder/placeholder"
          "catalog/placeholder/image_placeholder"
          "catalog/placeholder/small_image_placeholder"
          "catalog/placeholder/swatch_image_placeholder"
          "catalog/placeholder/thumbnail_placeholder"
          "catalog/review/allow_guest"
          "catalog/layered_navigation/display_product_count"
          "catalog/seo/product_use_categories"
          "catalog/seo/category_canonical_tag"
          "catalog/seo/product_canonical_tag"
          "catalog/search/search_recommendations_enabled"
          "catalog/search/search_recommendations_count"
          "catalog/search/search_recommendations_count_results_enabled"
          "catalog/search/search_suggestion_enabled"
          "catalog/search/search_suggestion_count"
          "catalog/search/search_suggestion_count_results_enabled"
          "catalog/search/elasticsearch_server_hostname"
          "catalog/search/elasticsearch_server_port"
          "catalog/search/elasticsearch_index_prefix"
          "catalog/search/elasticsearch_enable_auth"
          "catalog/search/elasticsearch_server_timeout"
          "catalog/search/elasticsearch5_server_hostname"
          "catalog/search/elasticsearch5_server_port"
          "catalog/search/elasticsearch5_index_prefix"
          "catalog/search/elasticsearch5_enable_auth"
          "catalog/search/elasticsearch5_server_timeout"
          "analytics/subscription/enabled" "analytics/general/collection_time"
          "analytics/general/vertical" "analytics/general/token"
          "analytics/url/signup" "analytics/url/update"
          "analytics/url/bi_essentials" "analytics/url/otp"
          "analytics/url/report" "analytics/url/notify_data_changed"
          "connector_dynamic_content/external_dynamic_content_urls/passcode"
          "connector_automation/review_settings/allow_non_subscribers"
          "connector_configuration/abandoned_carts/allow_non_subscribers"
          "sync_settings/addressbook/allow_non_subscribers"
          "design/theme/theme_id" "design/pagination/pagination_frame"
          "design/pagination/pagination_frame_skip"
          "design/pagination/anchor_text_for_previous"
          "design/pagination/anchor_text_for_next" "design/head/default_title"
          "design/head/title_prefix" "design/head/title_suffix"
          "design/head/default_description" "design/head/default_keywords"
          "design/head/includes" "design/head/demonotice"
          "design/head/shortcut_icon" "design/header/logo_src"
          "design/header/logo_width" "design/header/logo_height"
          "design/header/logo_alt" "design/header/welcome"
          "design/footer/copyright" "design/footer/absolute_footer"
          "design/footer/report_bugs"
          "design/search_engine_robots/default_robots"
          "design/search_engine_robots/custom_instructions"
          "design/watermark/image_size" "design/watermark/image_imageOpacity"
          "design/watermark/image_position" "design/watermark/small_image_size"
          "design/watermark/small_image_imageOpacity"
          "design/watermark/small_image_position"
          "design/watermark/thumbnail_size"
          "design/watermark/thumbnail_imageOpacity"
          "design/watermark/thumbnail_position"
          "design/watermark/swatch_image_size"
          "design/watermark/swatch_image_imageOpacity"
          "design/watermark/swatch_image_position" "design/email/logo_alt"
          "design/email/logo_width" "design/email/logo_height"
          "design/email/header_template" "design/email/footer_template"
          "design/email/logo" "mgstheme/general/width"
          "mgstheme/general/layout_style" "mgstheme/general/layout"
          "mgstheme/general/header" "mgstheme/general/footer"
          "mgstheme/general/sticky_menu" "mgstheme/general/back_to_top"
          "mgstheme/general/popup_newsletter" "mgstheme/general/breadcrumb"
          "mgstheme/fonts/default_font" "mgstheme/fonts/h1" "mgstheme/fonts/h2"
          "mgstheme/fonts/h3" "mgstheme/fonts/h4" "mgstheme/fonts/h5"
          "mgstheme/fonts/h6" "mgstheme/fonts/btn" "mgstheme/fonts/price"
          "mgstheme/fonts/menu" "mgstheme/fonts/menu_link"
          "mgstheme/fonts/custom_fonts_element" "mgstheme/fonts/custom_font_fml"
          "mgstheme/fonts/default_font_size" "mgstheme/fonts/h1_font_size"
          "mgstheme/fonts/h2_font_size" "mgstheme/fonts/h3_font_size"
          "mgstheme/fonts/h4_font_size" "mgstheme/fonts/h5_font_size"
          "mgstheme/fonts/h6_font_size" "mgstheme/fonts/price_font_size"
          "mgstheme/fonts/btn_font_size" "mgstheme/fonts/menu_font_size"
          "mgstheme/fonts/menu_link_font_size" "mgstheme/fonts/custom_font_size"
          "mgstheme/background/background_color"
          "mgstheme/background/background_cover"
          "mgstheme/background/background_repeat"
          "mgstheme/background/background_position_x"
          "mgstheme/background/background_position_y"
          "mgstheme/background/background_image"
          "mgstheme/custom_style/font_name" "mgstheme/custom_style/style"
          "mgstheme/custom_style/ttf_file" "mgstheme/custom_style/eot_file"
          "mgstheme/custom_style/woff_file" "mgstheme/custom_style/svg_file"
          "mpanel/catalog/product_per_row" "mpanel/catalog/max_width_image"
          "mpanel/catalog/max_width_image_detail" "mpanel/catalog/sale_label"
          "mpanel/catalog/new_label" "mpanel/catalog/picture_ratio"
          "mpanel/catalog/featured" "mpanel/catalog/hot"
          "mpanel/catalog/preload" "mpanel/catalog/wishlist_button"
          "mpanel/catalog/compare_button"
          "mpanel/form_mini_search/show_categories"
          "mpanel/contact_google_map/display_google_map"
          "mpanel/contact_google_map/api_key"
          "mpanel/contact_google_map/address_google_map"
          "mpanel/contact_google_map/html_google_map"
          "mpanel/contact_google_map/pin_google_map"
          "mpanel/product_details/sku" "mpanel/product_details/reviews_summary"
          "mpanel/product_details/wishlist" "mpanel/product_details/compare"
          "mpanel/product_details/short_description"
          "mpanel/product_details/upsell_products"
          "mpanel/product_tabs/show_description"
          "mpanel/product_tabs/show_additional"
          "mpanel/product_tabs/show_reviews" "mpanel/customer/account_dashboard"
          "mpanel/customer/account_information" "mpanel/customer/address_book"
          "mpanel/customer/downloadable" "mpanel/customer/orders"
          "mpanel/customer/newsletter" "mpanel/customer/billing_agreements"
          "mpanel/customer/reviews" "mpanel/customer/wishlist"
          "color/footer/footer_custom" "color/footer/footer_social_color"
          "color/footer/footer_social_color_hover"
          "color/footer/footer_social_background"
          "color/footer/footer_social_background_hover"
          "color/footer/footer_social_border"
          "color/footer/footer_social_border_hover" "color/general/theme_color"
          "color/header/header_custom" "color/main/main_custom"
          "crontab/default/jobs/catalog_product_alert/schedule/cron_expr"
          "crontab/default/jobs/catalog_product_alert/run/model"
          "crontab/default/jobs/currency_rates_update/schedule/cron_expr"
          "crontab/default/jobs/analytics_collect_data/schedule/cron_expr"
          "crontab/default/jobs/sitemap_generate/schedule/cron_expr"
          "crontab/default/jobs/sitemap_generate/run/model"
          "crontab/default/jobs/vertex_log_rotation/schedule/cron_expr"
          "brand/general_settings/enabled" "brand/general_settings/route"
          "brand/list_page_settings/title" "brand/list_page_settings/template"
          "brand/list_page_settings/small_image_width"
          "brand/list_page_settings/small_image_height"
          "brand/list_page_settings/show_brand_name"
          "brand/list_page_settings/show_product_count"
          "brand/list_page_settings/show_featured_brands"
          "brand/list_page_settings/meta_keywords"
          "brand/list_page_settings/meta_description"
          "brand/list_page_settings/description"
          "brand/view_page_settings/template"
          "brand/view_page_settings/image_width"
          "brand/view_page_settings/image_height"
          "brand/product_page_settings/show_brand"
          "brand/product_page_settings/small_image_width"
          "brand/product_page_settings/small_image_height"
          "brand/product_page_settings/show_related_products_by_brand"
          "brand/product_page_settings/title_related_products"
          "brand/product_page_settings/limit_related_products"
          "brand/sidebar_settings/enabled"
          "brand/sidebar_settings/show_brand_name"
          "brand/sidebar_settings/show_product_count"
          "brand/sidebar_settings/small_image_width"
          "brand/sidebar_settings/small_image_height"
          "brand/sidebar_settings/number_of_brands"
          "amasty_base/system_value/first_module_run"
          "amasty_base/system_value/last_update"
          "amasty_base/system_value/remove_date"
          "payment/amazon_payments/simplepath/publickey"
          "payment/amazon_payments/simplepath/privatekey"
          "payment/paypal_express/active" "payment/paypal_express/in_context"
          "payment/paypal_express/title" "payment/paypal_express/sort_order"
          "payment/paypal_express/payment_action"
          "payment/paypal_express/visible_on_product"
          "payment/paypal_express/visible_on_cart"
          "payment/paypal_express/allowspecific" "payment/paypal_express/debug"
          "payment/paypal_express/verify_peer"
          "payment/paypal_express/line_items_enabled"
          "payment/paypal_express/transfer_shipping_options"
          "payment/paypal_express/solution_type"
          "payment/paypal_express/require_billing_address"
          "payment/paypal_express/allow_ba_signup"
          "payment/paypal_express/skip_order_review_step"
          "payment/paypal_express/merchant_id"
          "payment/paypal_billing_agreement/active"
          "payment/paypal_billing_agreement/title"
          "payment/paypal_billing_agreement/sort_order"
          "payment/paypal_billing_agreement/payment_action"
          "payment/paypal_billing_agreement/allowspecific"
          "payment/paypal_billing_agreement/debug"
          "payment/paypal_billing_agreement/verify_peer"
          "payment/paypal_billing_agreement/line_items_enabled"
          "payment/paypal_billing_agreement/allow_billing_agreement_wizard"
          "payment/braintree/active" "payment/braintree/title"
          "payment/braintree/environment" "payment/braintree/payment_action"
          "payment/braintree/merchant_id" "payment/braintree/public_key"
          "payment/braintree/private_key"
          "payment/braintree/merchant_account_id"
          "payment/braintree/fraudprotection" "payment/braintree/debug"
          "payment/braintree/useccv" "payment/braintree/cctypes"
          "payment/braintree/sort_order" "payment/braintree/allowspecific"
          "payment/braintree/specificcountry"
          "payment/braintree/countrycreditcard"
          "payment/braintree/verify_3dsecure"
          "payment/braintree/threshold_amount"
          "payment/braintree/verify_all_countries"
          "payment/braintree/verify_specific_countries"
          "payment/braintree/descriptor_name"
          "payment/braintree/descriptor_phone"
          "payment/braintree/descriptor_url" "payment/braintree_paypal/active"
          "payment/braintree_paypal/title" "payment/braintree_paypal/sort_order"
          "payment/braintree_paypal/merchant_name_override"
          "payment/braintree_paypal/payment_action"
          "payment/braintree_paypal/allowspecific"
          "payment/braintree_paypal/specificcountry"
          "payment/braintree_paypal/require_billing_address"
          "payment/braintree_paypal/allow_shipping_address_override"
          "payment/braintree_paypal/debug"
          "payment/braintree_paypal/display_on_shopping_cart"
          "payment/braintree_paypal/skip_order_review"
          "payment/braintree_cc_vault/active" "payment/braintree_cc_vault/title"
          "payment/braintree_paypal_vault/active" "payment/hosted_pro/active"
          "payment/hosted_pro/title" "payment/hosted_pro/sort_order"
          "payment/hosted_pro/payment_action" "payment/hosted_pro/display_ec"
          "payment/hosted_pro/allowspecific" "payment/hosted_pro/debug"
          "payment/hosted_pro/verify_peer" "payment/wps_express/active"
          "payment/klarna_kp/active" "payment/klarna_kp/allowspecific"
          "payment/klarna_kp/data_sharing" "payment/klarna_kp/sort_order"
          "payment/amazon_payment/merchant_id"
          "payment/amazon_payment/access_key"
          "payment/amazon_payment/secret_key" "payment/amazon_payment/client_id"
          "payment/amazon_payment/client_secret"
          "payment/amazon_payment/credentials_json"
          "payment/amazon_payment/payment_region"
          "payment/amazon_payment/sandbox" "payment/amazon_payment/active"
          "payment/amazon_payment/lwa_enabled"
          "payment/amazon_payment/payment_action"
          "payment/amazon_payment/authorization_mode"
          "payment/amazon_payment/update_mechanism"
          "payment/amazon_payment/button_display_language"
          "payment/amazon_payment/button_color"
          "payment/amazon_payment/button_size"
          "payment/amazon_payment/amazon_login_in_popup"
          "payment/amazon_payment/pwa_pp_button_is_visible"
          "payment/amazon_payment/minicart_button_is_visible"
          "payment/amazon_payment/storename" "payment/amazon_payment/logging"
          "payment/amazon_payment/allowed_ips" "payment/amazonlogin/active"
          "payment/cashondelivery/specificcountry"
          "payment/cashondelivery/instructions"
          "payment/cashondelivery/min_order_total"
          "payment/cashondelivery/max_order_total"
          "payment/cashondelivery/sort_order" "payment/free/specificcountry"
          "payment/checkmo/specificcountry" "payment/checkmo/payable_to"
          "payment/checkmo/mailing_address" "payment/checkmo/min_order_total"
          "payment/checkmo/max_order_total" "payment/checkmo/sort_order"
          "payment/checkmo/active" "payment/banktransfer/specificcountry"
          "payment/banktransfer/instructions"
          "payment/banktransfer/min_order_total"
          "payment/banktransfer/max_order_total"
          "payment/banktransfer/sort_order" "payment/banktransfer/active"
          "payment/banktransfer/title" "payment/banktransfer/order_status"
          "payment/purchaseorder/specificcountry"
          "payment/purchaseorder/min_order_total"
          "payment/purchaseorder/max_order_total"
          "payment/purchaseorder/sort_order"
          "payment/authorizenet_directpost/login"
          "payment/authorizenet_directpost/trans_key"
          "payment/authorizenet_directpost/trans_md5"
          "payment/authorizenet_directpost/merchant_email"
          "payment/authorizenet_directpost/useccv"
          "payment/authorizenet_directpost/specificcountry"
          "payment/authorizenet_directpost/min_order_total"
          "payment/authorizenet_directpost/max_order_total"
          "payment/authorizenet_directpost/sort_order"
          "payment/authorizenet_directpost/debug"
          "payment/authorizenet_directpost/email_customer"
          "payment/authorizenet_directpost/test"
          "payment/authorizenet_directpost/cgi_url"
          "payment/authorizenet_directpost/cgi_url_td"
          "payment/monetaweb2common/test_gateway_url"
          "payment/monetaweb2common/test_terminal_id"
          "payment/monetaweb2common/test_terminal_password"
          "payment/monetaweb2common/gateway_url"
          "payment/monetaweb2common/terminal_id"
          "payment/monetaweb2common/terminal_password"
          "payment/monetaweb2common/debug"
          "payment/monetaweb2common/cancel_on_failure"
          "payment/monetaweb2/active" "payment/monetaweb2/title"
          "payment/monetaweb2/test_mode" "payment/monetaweb2/payment_action"
          "payment/monetaweb2/language" "payment/monetaweb2/currency"
          "payment/monetaweb2/allowspecific"
          "payment/monetaweb2/specificcountry"
          "payment/monetaweb2/min_order_total"
          "payment/monetaweb2/max_order_total" "payment/monetaweb2/sort_order"
          "payment/monetaweb2mybank/active" "payment/monetaweb2mybank/title"
          "payment/monetaweb2mybank/test_mode"
          "payment/monetaweb2mybank/language"
          "payment/monetaweb2mybank/currency"
          "payment/monetaweb2mybank/allowspecific"
          "payment/monetaweb2mybank/specificcountry"
          "payment/monetaweb2mybank/min_order_total"
          "payment/monetaweb2mybank/max_order_total"
          "payment/monetaweb2mybank/sort_order"
          "payment/authorizenet_acceptjs/cctypes"
          "payment/authorizenet_acceptjs/order_status"
          "payment/authorizenet_acceptjs/payment_action"
          "payment/authorizenet_acceptjs/currency"
          "payment/authorizenet_acceptjs/email_customer"
          "payment/authorizenet_acceptjs/login"
          "payment/authorizenet_acceptjs/trans_key"
          "payment/authorizenet_acceptjs/trans_md5" "payment/payflowpro/user"
          "payment/payflowpro/pwd" "payment/payflow_link/pwd"
          "payment/payflow_link/url_method" "payment/payflow_advanced/user"
          "payment/payflow_advanced/pwd" "payment/payflow_advanced/url_method"
          "trans_email/ident_general/email" "trans_email/ident_general/name"
          "trans_email/ident_sales/email" "trans_email/ident_sales/name"
          "trans_email/ident_support/email" "trans_email/ident_support/name"
          "trans_email/ident_custom1/email" "trans_email/ident_custom1/name"
          "trans_email/ident_custom2/email" "trans_email/ident_custom2/name"
          "contact/email/recipient_email"
          "cataloginventory/options/show_out_of_stock"
          "cataloginventory/item_options/auto_return"
          "cataloginventory/item_options/notify_stock_qty"
          "sitemap/category/priority" "sitemap/page/priority"
          "sitemap/generate/enabled" "sitemap/generate/time"
          "sitemap/generate/frequency" "sitemap/generate/error_email"
          "sitemap/search_engines/submission_robots" "sendfriend/email/enabled"
          "sales/general/hide_customer_ip" "sales/identity/address"
          "sales/identity/logo" "sales/identity/logo_html"
          "sales/minimum_order/active" "sales/minimum_order/amount"
          "sales/minimum_order/description" "sales/minimum_order/error_message"
          "sales/minimum_order/multi_address"
          "sales/minimum_order/multi_address_description"
          "sales/minimum_order/multi_address_error_message"
          "sales/orders/delete_pending_after" "sales/gift_options/allow_items"
          "sales_email/order/copy_to" "sales_email/order_comment/copy_to"
          "sales_email/invoice/enabled" "sales_email/invoice/copy_to"
          "sales_email/invoice_comment/enabled"
          "sales_email/invoice_comment/copy_to" "sales_email/shipment/copy_to"
          "sales_email/shipment_comment/copy_to"
          "sales_email/creditmemo/enabled" "sales_email/creditmemo/copy_to"
          "sales_email/creditmemo_comment/enabled"
          "sales_email/creditmemo_comment/copy_to"
          "checkout/options/display_billing_address_on"
          "checkout/options/enable_agreements"
          "checkout/options/onepage_checkout_enabled"
          "checkout/options/guest_checkout" "checkout/payment_failed/copy_to"
          "checkout/payment_failed/copy_method"
          "checkout/klarna_kp_design/color_details"
          "checkout/klarna_kp_design/color_border"
          "checkout/klarna_kp_design/color_border_selected"
          "checkout/klarna_kp_design/color_text"
          "checkout/klarna_kp_design/color_radius_border"
          "shipping/origin/country_id" "shipping/origin/region_id"
          "shipping/origin/postcode" "shipping/origin/city"
          "shipping/origin/street_line1" "shipping/origin/street_line2"
          "shipping/shipping_policy/enable_shipping_policy"
          "shipping/shipping_policy/shipping_policy_content"
          "multishipping/options/checkout_multiple"
          "paypal/general/merchant_country" "paypal/general/business_account"
          "paypal/wpp/api_authentication" "paypal/wpp/api_username"
          "paypal/wpp/api_password" "paypal/wpp/api_signature"
          "paypal/wpp/sandbox_flag" "paypal/wpp/use_proxy"
          "paypal/wpp/button_flavor" "paypal/fetch_reports/ftp_login"
          "paypal/fetch_reports/ftp_password" "paypal/fetch_reports/ftp_sandbox"
          "paypal/fetch_reports/ftp_ip" "paypal/fetch_reports/ftp_path"
          "paypal/fetch_reports/active" "paypal/fetch_reports/schedule"
          "paypal/fetch_reports/time" "paypal/style/logo"
          "paypal/style/page_style" "paypal/style/paypal_hdrimg"
          "paypal/style/paypal_hdrbackcolor"
          "paypal/style/paypal_hdrbordercolor"
          "paypal/style/paypal_payflowcolor" "klarna/api/api_version"
          "klarna/api/merchant_id" "klarna/api/shared_secret"
          "klarna/api/test_mode" "klarna/api/debug"
          "customer/address/street_lines" "customer/address/prefix_show"
          "customer/address/prefix_options" "customer/address/middlename_show"
          "customer/address/suffix_show" "customer/address/suffix_options"
          "customer/address/dob_show" "customer/address/taxvat_show"
          "customer/address/gender_show" "customer/address/telephone_show"
          "customer/address/company_show" "customer/address/fax_show"
          "customer/online_customers/online_minutes_interval"
          "customer/online_customers/section_data_lifetime"
          "customer/create_account/auto_group_assign"
          "customer/create_account/viv_disable_auto_group_assign_default"
          "customer/create_account/generate_human_friendly_id"
          "customer/create_account/viv_domestic_group"
          "customer/create_account/viv_intra_union_group"
          "customer/create_account/viv_invalid_group"
          "customer/create_account/viv_error_group"
          "customer/create_account/viv_on_each_transaction"
          "customer/create_account/vat_frontend_visibility"
          "customer/create_account/email_domain"
          "customer/password/required_character_classes_number"
          "customer/password/minimum_password_length" "webapi/soap/charset"
          "webapi/webapisecurity/allow_insecure" "megamenu/general/home"
          "megamenu/general/hometext" "dev/restrict/allow_ips"
          "dev/template/allow_symlink" "dev/debug/template_hints_storefront"
          "dev/debug/template_hints_admin" "dev/debug/template_hints_blocks"
          "dev/debug/debug_logging"
          "dev/debug/template_hints_storefront_show_with_parameter"
          "dev/translate_inline/active" "dev/translate_inline/active_admin"
          "dev/js/merge_files" "dev/js/enable_js_bundling" "dev/js/minify_files"
          "dev/js/session_storage_key" "dev/css/merge_css_files"
          "dev/css/minify_files" "dev/static/sign"
          "dev/front_end_development_workflow/type"
          "system/full_page_cache/varnish/access_list"
          "system/full_page_cache/varnish/backend_host"
          "system/full_page_cache/varnish/backend_port"
          "system/full_page_cache/varnish/grace_period"
          "system/smtp/set_return_path" "system/smtp/host" "system/smtp/port"
          "system/currency/installed" "system/backup/enabled"
          "mgs_quickview/general/enabled"
          "mgs_quickview/general/hide_product_image"
          "mgs_quickview/general/hide_product_image_thumb"
          "mgs_quickview/general/hide_short_description"
          "mgs_quickview/general/hide_qty"
          "mgs_quickview/general/hide_availability"
          "mgs_quickview/general/hide_sku"
          "mgs_quickview/general/hide_product_social_links"
          "mgs_quickview/general/button_style" "locator/general/top_link"
          "locator/general/top_link_label" "amgeoip/import/block"
          "amgeoip/import/location" "amgeoip/import/position/block"
          "amgeoip/import/position/location" "amgeoip/import/tmp_table/block"
          "amgeoip/import/tmp_table/location" "amgeoip/import/rows_count/block"
          "amgeoip/import/rows_count/location"
          "amgeoip/import/current_row/block"
          "amgeoip/import/current_row/location" "amgeoip/import/date_download"
          "amgeoipredirect/general/enable"
          "amgeoipredirect/restriction/apply_logic"
          "amgeoipredirect/restriction/accepted_urls"
          "amgeoipredirect/restriction/excepted_urls"
          "amgeoipredirect/restriction/user_agents_ignore"
          "amgeoipredirect/restriction/ip_restriction"
          "amgeoipredirect/restriction/first_visit_redirect"
          "amgeoipredirect/restriction/redirect_between_websites"
          "amgeoipredirect/country_store/enable_store"
          "amgeoipredirect/country_currency/enable_currency"
          "amgeoipredirect/country_currency/currency_mapping"
          "amgeoipredirect/country_url/enable_url"
          "amgeoipredirect/country_url/url_mapping"
          "admin/security/admin_account_sharing"
          "admin/security/use_case_sensitive_login"
          "admin/security/session_lifetime" "admin/url/custom"
          "mailchimp/general/active" "mailchimp/general/apikeylist"
          "mailchimp/general/apikey" "mailchimp/general/monkeylist"
          "mailchimp/general/magentoemail" "mailchimp/general/webhook_active"
          "mailchimp/general/webhook_delete" "mailchimp/general/log"
          "mailchimp/general/map_fields" "mailchimp/general/interest"
          "mailchimp/general/interest_in_success"
          "mailchimp/general/interest_success_html_before"
          "mailchimp/general/interest_success_html_after"
          "mailchimp/general/issync/c143a218738d7d1e610a345b93761f5a"
          "mailchimp/general/issync/a0e723a18476fecc3d11c3544fda2c31"
          "mailchimp/general/monkeystore" "mailchimp/ecommerce/active"
          "mailchimp/ecommerce/customer_optin" "mailchimp/ecommerce/firstdate"
          "mailchimp/ecommerce/send_promo" "mailchimp/ecommerce/including_taxes"
          "mailchimp/abandonedcart/active" "mailchimp/abandonedcart/firstdate"
          "mailchimp/abandonedcart/page" "social/general_settings/active"
          "social/general_settings/show_social_login_on_header_links"
          "social/general_settings/show_social_login_on_customer_login"
          "social/facebook_settings/active" "social/google_settings/active"
          "social/twitter_settings/active"
          "social/instagram_setting/enable_instagram"
          "magma_taxcode/main/enabled" "magma_taxcode/main/request_invoice"
          "aw_rma/general/return_period" "aw_rma/general/allow_guest_requests"
          "aw_rma/general/confirm_shipping_popup_text"
          "aw_rma/general/allow_auto_approve"
          "aw_rma/blocks_and_policy/guest_rma_block"
          "aw_rma/blocks_and_policy/product_selection_block"
          "aw_rma/blocks_and_policy/reasons_and_details_block"
          "aw_rma/blocks_and_policy/policy_block"
          "aw_rma/contacts/department_name" "aw_rma/contacts/department_email"
          "aw_rma/contacts/department_address"
          "aw_rma/email/template_to_customer_thread"
          "aw_rma/email/template_to_admin_thread"
          "aw_rma/file_attachments/allow_attach_files"
          "aw_rma/file_attachments/max_upload_file_size"
          "aw_rma/file_attachments/allow_file_extensions"
          "bss_guest_to_customer/bss_guest_to_customer_general/enable"
          "bss_guest_to_customer/bss_guest_to_customer_general/assign_orders"
          "bss_guest_to_customer/bss_guest_to_customer_general/auto_convert"
          "bss_guest_to_customer/bss_guest_to_customer_general/customer_group"
          "bss_guest_to_customer/bss_guest_to_customer_email/enable_email"
          "bss_guest_to_customer/bss_guest_to_customer_email/email_sender"
          "bss_guest_to_customer/bss_guest_to_customer_email/email_template"
          "bss_guest_to_customer/bss_require_field/gender_require_field"
          "bss_guest_to_customer/bss_require_field/taxvat_require_field"
          "bss_guest_to_customer/bss_require_field/suffix_require_field"
          "bss_guest_to_customer/bss_require_field/prefix_require_field"
          "bss_guest_to_customer/bss_require_field/fax_require_field"
          "bss_guest_to_customer/bss_require_field/telephone_require_field"
          "bss_guest_to_customer/bss_require_field/company_require_field"
          "bss_guest_to_customer/bss_require_field/dob_require_field"
          "carriers/flatrate/handling_fee" "carriers/flatrate/specificcountry"
          "carriers/flatrate/showmethod" "carriers/flatrate/sort_order"
          "carriers/flatrate/active"
          "carriers/freeshipping/free_shipping_subtotal"
          "carriers/freeshipping/specificcountry"
          "carriers/freeshipping/showmethod" "carriers/freeshipping/sort_order"
          "carriers/tablerate/active" "carriers/tablerate/title"
          "carriers/tablerate/name" "carriers/tablerate/condition_name"
          "carriers/tablerate/handling_fee" "carriers/tablerate/specificcountry"
          "carriers/tablerate/showmethod" "carriers/tablerate/sort_order"
          "carriers/tablerate/include_virtual_price"
          "carriers/tablerate/handling_type" "carriers/temando/active"
          "carriers/temando/title" "carriers/temando/logging_enabled"
          "carriers/temando/session_endpoint" "carriers/temando/account_id"
          "carriers/temando/bearer_token"
          "carriers/temando/collectionpoints_enabled"
          "carriers/temando/collectionpoints_countries"
          "carriers/temando/sallowspecific" "carriers/temando/specificcountry"
          "carriers/temando/showmethod" "carriers/temando/specificerrmsg"
          "carriers/temando/sort_order" "free/module/email" "free/module/name"
          "free/module/create" "free/module/subscribe" "smtp/module/active"
          "smtp/module/product_key" "smtp/module/email" "smtp/module/name"
          "smtp/module/create" "smtp/module/subscribe" "smtp/general/enabled"
          "smtp/general/log_email" "smtp/general/clean_email"
          "smtp/configuration_option/host" "smtp/configuration_option/port"
          "smtp/configuration_option/protocol"
          "smtp/configuration_option/authentication"
          "smtp/configuration_option/username"
          "smtp/configuration_option/password"
          "smtp/configuration_option/return_path_email"
          "smtp/configuration_option/test_email/from"
          "smtp/configuration_option/test_email/to"
          "smtp/developer/developer_mode" "mageplaza/general/notice_enable"
          "mageplaza/general/notice_type" "mageplaza/general/menu"
          "betterpopup/general/enabled" "betterpopup/what_to_show/html_content"
          "betterpopup/what_to_show/responsive" "betterpopup/what_to_show/width"
          "betterpopup/what_to_show/height"
          "betterpopup/what_to_show/background_color"
          "betterpopup/what_to_show/text_color"
          "betterpopup/what_to_show/popup_success/coupon_code"
          "betterpopup/what_to_show/popup_success/html_success_content"
          "betterpopup/what_to_show/popup_success/enabled_fireworks"
          "betterpopup/where_to_show/which_page_to_show"
          "betterpopup/where_to_show/include_pages"
          "betterpopup/where_to_show/include_pages_with_url"
          "betterpopup/where_to_show/exclude_pages"
          "betterpopup/where_to_show/exclude_pages_with_url"
          "betterpopup/when_to_show/popup_appear"
          "betterpopup/when_to_show/cookieExp"
          "betterpopup/when_to_show/show_float_button"
          "betterpopup/send_email/isSendEmail" "betterpopup/send_email/to"
          "cookienotice/general/enabledisable" "cookienotice/general/type"
          "cookienotice/general/box_position" "cookienotice/general/behaviour"
          "cookienotice/general/auto_hide_after" "cookienotice/general/onscroll"
          "cookienotice/general/auto_accept" "cookienotice/general/expire"
          "cookienotice/content/show" "cookienotice/content/newtab"
          "cookienotice/content/cms_page" "cookienotice/content/custom_message"
          "cookienotice/content/model_title"
          "cookienotice/content/custom_accept"
          "cookienotice/content/custom_close"
          "cookienotice/content/custom_more_info"
          "cookienotice/popup_style/font_family"
          "cookienotice/popup_style/model_text_align"
          "cookienotice/popup_style/model_title_size"
          "cookienotice/popup_style/model_message_size"
          "cookienotice/popup_style/model_border"
          "cookienotice/popup_style/continer_top_border"
          "cookienotice/popup_style/container_bottom_border"
          "cookienotice/popup_style/header_bottom_border_color"
          "cookienotice/popup_style/footer_top_border_color"
          "cookienotice/popup_style/header_background_color"
          "cookienotice/popup_style/header_font_color"
          "cookienotice/popup_style/accept_button_background_color"
          "cookienotice/popup_style/close_button_background_color"
          "cookienotice/popup_style/policy_button_background_color"
          "cookienotice/popup_style/close_button_color"
          "cookienotice/popup_style/privace_policy_color"
          "cookienotice/popup_style/accept_button_color"
          "cookienotice/popup_style/model_title_color"
          "tax/vertex_settings/enable_vertex" "tax/vertex_seller_info/company"
          "tax/vertex_seller_info/location_code"
          "tax/vertex_seller_info/streetAddress1"
          "tax/vertex_seller_info/streetAddress2" "tax/vertex_seller_info/city"
          "tax/vertex_seller_info/country_id" "tax/vertex_seller_info/region_id"
          "tax/vertex_seller_info/postalCode" "tax/classes/shipping_tax_class"
          "tax/classes/default_product_tax_class"
          "tax/classes/default_customer_code"
          "tax/classes/creditmemo_adjustment_class"
          "tax/classes/creditmemo_adjustment_negative_code"
          "tax/classes/creditmemo_adjustment_positive_code"
          "tax/calculation/price_includes_tax"
          "tax/calculation/shipping_includes_tax" "tax/calculation/discount_tax"
          "tax/calculation/cross_border_trade_enabled"
          "tax/notification/ignore_discount"
          "tax/notification/ignore_price_display"
          "tax/notification/ignore_apply_discount" "tax/defaults/country"
          "tax/defaults/postcode" "tax/display/type" "tax/display/shipping"
          "tax/cart_display/price" "tax/cart_display/subtotal"
          "tax/cart_display/shipping" "tax/cart_display/grandtotal"
          "tax/sales_display/price" "tax/sales_display/subtotal"
          "tax/sales_display/shipping" "tax/sales_display/grandtotal"
          "google/analytics/active" "google/analytics/account"
          "google/analytics/anonymize" "google/analytics/experiments"
          "apptrian_facebookpixel/general/enabled"
          "apptrian_facebookpixel/general/pixel_id"
          "veslicense/general/vesmegamneu" "cms/wysiwyg/enabled"
          "cms/wysiwyg/use_static_urls_in_catalog" "delete_orders/module/active"
          "delete_orders/module/product_key" "delete_orders/module/email"
          "delete_orders/module/name" "delete_orders/module/create"
          "delete_orders/module/subscribe" "ampromo/general/auto_add"
          "ampromo/messages/gift_selection_method"
          "ampromo/messages/popup_title" "ampromo/messages/add_button_title"
          "ampromo/messages/cart_message" "ampromo/messages/prefix"
          "ampromo/messages/add_message" "ampromo/messages/auto_open_popup"
          "ampromo/messages/show_price_in_popup"
          "ampromo/messages/display_error_messages"
          "ampromo/messages/display_success_messages"
          "ampromo/messages/display_remaining_gifts_counter"
          "ampromo/messages/display_notification"
          "ampromo/messages/notification_text"
          "ampromo/limitations/skip_special_price" "ampromo/banners/mode"
          "ampromo/banners/enabled_top" "ampromo/banners/enabled_above_cart"
          "ampromo/banners/single" "ampromo/gift_images/gift_image_width"
          "ampromo/gift_images/gift_image_height"
          "ampromo/gift_images/attribute_header"
          "ampromo/gift_images/attribute_description"
          "msp_securitysuite_twofactorauth/duo/application_key"
          "vesmegamenu/general_settings/enable_backup"
          "vesmegamenu/general_settings/backup_version"
          "vesmegamenu/general_settings/enable_minify"
          "vesmegamenu/general_settings/enable_mobile_menu"
          "vesall/general/enable_bootstrap_js"
          "vesall/general/enable_owlcarousel" "vesall/general/enable_colorbox"
          "vesall/general/enable_fancybox"
          "vesall/general/enable_fancybox_mousewell" "vesall/general/custom_css"
          "newrelicreporting/general/api_url"
          "newrelicreporting/general/insights_api_url"
          "fraud_protection/signifyd/api_url"
          "fraud_protection/signifyd/api_key")))

;;;###autoload (autoload 'pcomplete/magento "pcomplete-declare-magento")
(pcomplete-declare magento
  (h --help :help "Display this help message")
  (q -quiet :help "Do not output any message")
  (V -version :help "Display this application version")
  (-ansi :help "Force ANSI output")
  (-no-ansi :help "Disable ANSI output")
  (n -no-interaction :help "Do not ask any interactive question")
  (v :help "Verbosity level: normal output")
  (vv :help "Verbosity level: more verbose output")
  (vvv -verbose :help "Verbosity level: debug")
  (-raw :help "To output raw command help")

  &option
  (-format :completions '("txt" "xml" "json" "md") :help "\
The output format (txt, xml, json, or md) [default: \"txt\"]")

  &subcommand
  (help :help "\
The help command displays help for a given command:
$ php ./magento help list
You can also output the help in other formats by using the --format option:
$ php ./magento help --format=xml list
To display the list of available commands, please use the list command."

        &positional
        (:completions pcomplete-declare-magento-subcommands
                      :help "The command name [default: \"help\"]"))
  (list :help "\
The list command lists all commands:
$ php ./magento list
You can also display the commands for a specific namespace:
$ php ./magento list test
You can also output the information in other formats by using the --format option:
$ php ./magento list --format=xml
It's also possible to get raw list of commands (useful for embedding command runner):
$ php ./magento list --raw"
        &positional
        (:completions #'pcomplete-declare-magento-namespaces
                      :help "The namespace name"))

  (admin:user:create
   :help "Creates an administrator"
   &option
   (-admin-user :completions '("ADMIN-USER") :help "(Required) Admin user")
   (-admin-password :completions '("ADMIN-PASSWORD") :help "(Required) Admin password")
   (-admin-email :completions '("ADMIN-EMAIL") :help "(Required) Admin email")
   (-admin-firstname :completions '("ADMIN-FIRSTNAME") :help "(Required) Admin first name")
   (-admin-lastname :completions '("ADMIN-LASTNAME") :help "(Required) Admin last name")
   (-magento-init-params :completions '("MAGENTO-INIT-PARAMS") :help "\
Add to any command to customize Magento initialization parameters
For example: \"MAGE_MODE=developer&MAGE_DIRS[base][path]=/var/www/example.com&M\
AGE_DIRS[cache][path]=/var/tmp/cache\""))

  (admin:user:unlock
   :help "\
This command unlocks an admin account by its username.
To unlock: ./magento admin:user:unlock username"
   &positional
   (:completions '("USERNAME") :help "The admin username to unlock"))

  (app:config:dump
   :help "Create dump of application"
   &positional
   (:completions '("scopes" "system" "themes" "i18n") :multiple t :help "\
Space-separated list of config types or omit to dump all
[scopes, system, themes, i18n]"))

  (app:config:import :help "\
Import data from shared configuration files to appropriate data storage")

  (app:config:status :help "Checks if config propagation requires update")

  (cache:clean
   :help "Cleans cache type(s)"

   &option
   (-bootstrap :completions '("BOOTSTRAP")
               :help "add or override parameters of the bootstrap")

   &positional
   (:completions pcomplete-declare-magento-cache-types :multiple t :help "\
Space-separated list of cache types or omit to apply to all cache types."))

  (cache:disable
   :help "Disables cache type(s)"

   &option
   (-bootstrap :completions '("BOOTSTRAP")
               :help "add or override parameters of the bootstrap")

   &positional
   (:completions pcomplete-declare-magento-cache-types :multiple t :help "\
Space-separated list of cache types or omit to apply to all cache types."))

  (cache:enable
   :help "Enables cache type(s)"

   &option
   (-bootstrap :completions '("BOOTSTRAP")
               :help "add or override parameters of the bootstrap")

   &positional
   (:completions pcomplete-declare-magento-cache-types :multiple t :help "\
Space-separated list of cache types or omit to apply to all cache types."))

  (cache:flush
   :help "Flushes cache storage used by cache type(s)"

   &option
   (-bootstrap :completions '("BOOTSTRAP")
               :help "add or override parameters of the bootstrap")

   &positional
   (:completions pcomplete-declare-magento-cache-types :multiple t :help "\
Space-separated list of cache types or omit to apply to all cache types."))

  (cache:status
   :help "Checks cache status"
   &option
   (-bootstrap :completions '("BOOTSTRAP")
               :help "add or override parameters of the bootstrap"))

  (catalog:images:resize :help "Creates resized product images")

  (catalog:product:attributes:cleanup
   :help "Removes unused product attributes.")

  (config:sensitive:set
   :help "Set sensitive configuration values"

   (i -interactive :help "Enable interactive mode to set all sensitive variables")
   &option
   (-scope :completions '("SCOPE") :help "\
Scope for configuration, if not set use 'default' [default: \"default\"]")
   (-scope-code :completions '("SCOPECODE") :help "\
Scope code for configuration, empty string by default [default: \"\"]")

   &positional
   (:completions pcomplete-declare-magento-config-options
                 :help "Configuration path for example group/section/field_name")
   (:completions '("VALUE") :help "Configuration value"))

  (config:set
   :help "Change system configuration"
   (le -lock-env :help "\
Lock value which prevents modification in the Admin (will be saved in app/etc/env.php)")
   (lc -lock-config :help "\
Lock and share value with other installations, prevents modification in the Admin (will be saved in app/etc/config.php)")

   &option
   (-scope :completions '("SCOPE") :help "\
Scope for configuration, if not set use 'default' [default: \"default\"]")
   (-scope-code :completions '("SCOPECODE") :help "\
Scope code for configuration, empty string by default [default: \"\"]")

   &positional
   (:completions pcomplete-declare-magento-config-options
                 :help "Configuration path for example group/section/field_name")
   (:completions '("VALUE") :help "Configuration value"))

  (config:show
   :help "\
Shows configuration value for given path. If path is not specified, all saved
values will be shown"

   &option
   (-scope :completions '("SCOPE") :help "\
Scope for configuration, if not set use 'default' [default: \"default\"]")
   (-scope-code :completions '("SCOPECODE") :help "\
Scope code for configuration, empty string by default [default: \"\"]")

   &positional
   (:completions pcomplete-declare-magento-config-options
                 :help "Configuration path for example group/section/field_name"))

  (cron:install :help "Generates and installs crontab for current user"
                (f -force :help "Force install tasks"))

  (cron:remove :help "Removes tasks from crontab")

  (cron:run
   :help "Runs jobs by schedule"
   &option
   (-group :completions '("GROUP") :help "Run jobs only from specified group")
   (-bootstrap :completions '("BOOTSTRAP")
               :help "Add or override parameters of the bootstrap"))

  (customer:hash:upgrade
   :help "Upgrade customer's hash according to the latest algorithm")

  (deploy:mode:set
   :help "Set application mode"
   (s -skip-compilation :help "\
Skips the clearing and regeneration of static content (generated code,
preprocessed CSS, and assets in pub/static/)")
   &positional
   (:completions '("developer" "production") :help "\
The application mode to set. Available options are \"developer\" or
\"production\""))

  (deploy:mode:show :help "Displays current application mode")
  (dev:di:info :help "\
Provides information on Dependency Injection configuration for the Command."
               &positional
               (:completions '("CLASS") :help "Class name"))

  (dev:profiler:disable :help "Disable the profiler.")
  (dev:profiler:enable :help "Enable the profiler."
                       &positional
                       (:completions '("TYPE") :help "Profiler type"))

  (dev:query-log:disable :help "Disable DB query logging")
  (dev:query-log:enable
   :help "Enable DB query logging"
   &option
   (-include-all-queries
    :completions '("true" "false")
    :help "Log all queries. [true|false] [default: \"true\"]")
   (-query-time-threshold
    :completions '("QUERYTIMETHRESHOLD")
    :help "Query time thresholds. [default: \"0.001\"]")
   (-include-call-stack
    :completions '("true" "false")
    :help "Include call stack. [true|false] [default: \"true\"]"))

  (dev:source-theme:deploy)
  (dev:template-hints:disable)
  (dev:template-hints:enable)
  (dev:tests:run)
  (dev:urn-catalog:generate)
  (dev:xml:convert)
  (encryption:payment-data:update)
  (i18n:collect-phrases)
  (i18n:pack)
  (i18n:uninstall)
  (indexer:info)
  (indexer:reindex)
  (indexer:reset)
  (indexer:set-dimensions-mode)
  (indexer:set-mode)
  (indexer:show-dimensions-mode)
  (indexer:show-mode)
  (indexer:status)
  (info:adminuri)
  (info:backups:list)
  (info:currency:list)
  (info:dependencies:show-framework)
  (info:dependencies:show-modules)
  (info:dependencies:show-modules-circular)
  (info:language:list)
  (info:timezone:list)
  (maintenance:allow-ips)
  (maintenance:disable)
  (maintenance:enable)
  (maintenance:status)
  (module:disable)
  (module:enable)
  (module:status)
  (module:uninstall)
  (msp:security:recaptcha:disable)
  (msp:security:tfa:disable)
  (msp:security:tfa:providers)
  (msp:security:tfa:reset)
  (newrelic:create:deploy-marker)
  (queue:consumers:list)
  (queue:consumers:start)
  (sampledata:deploy)
  (sampledata:remove)
  (sampledata:reset)
  (setup:backup)
  (setup:config:set)
  (setup:cron:run)
  (setup:db-data:upgrade)
  (setup:db-declaration:generate-patch)
  (setup:db-declaration:generate-whitelist)
  (setup:db-schema:upgrade)
  (setup:db:status)
  (setup:di:compile)
  (setup:install)
  (setup:performance:generate-fixtures)
  (setup:rollback)
  (setup:static-content:deploy)
  (setup:store-config:set)
  (setup:uninstall)
  (setup:upgrade)
  (store:list)
  (store:website:list)
  (theme:uninstall)
  (varnish:vcl:generate))

(provide 'pcomplete-declare-magento)
;;; pcomplete-declare-magento.el ends here
