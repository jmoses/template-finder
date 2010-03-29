module TemplateFinder
  module Mapper
    extend self
    
    @@template_map = nil
    @@template_cache = {}
    
    def map
      @@template_map ||= load_map
    end

    def load_map
      @@template_map = Hash[ *[
        #Product
        Template.new( :product, "products/show" ),
        Template.new( :product_list, "products/list", :partial => true ),
        Template.new( :search_results, 'products/search' ),
        Template.new( :customer_product_reviews, "customer_product_reviews/index"),
        Template.new( :latest_product_reviews, "customer_product_reviews/latest_reviews", :partial => true),
        Template.new( :product_review, "customer_product_reviews/review", :partial=>true),
        Template.new( :product_review_popup, "customer_product_reviews/popup", :partial=>true),
        Template.new( :product_review_popup_form, "customer_product_reviews/popup_form", :partial=>true),
        Template.new( :product_action_shots, "action_images/product_action_shots", :partial => true),
        Template.new( :products_periodic_content, 'products/periodic_content', :partial => true),
        Template.new( :product_options, 'products/options', :partial => true),
        Template.new( :tell_friend, "products/tell_a_friend", :partial => true),
        Template.new( :gift_certificate_personalization, 'products/gift_certificate_personalization', :partial => true ),
        Template.new( :action_image, "action_images/show"),
        Template.new( :stock_notification_form, "products/stock_notification_form", :partial => true ),
        #Category
        Template.new( :category, "categories/show"),
        #Cart
        Template.new( :cart, 'cart/show' ),
        Template.new( :cart_item, 'cart/cart_item', :partial => true ),
        Template.new( :cart_footer, 'cart/cart_footer', :partial => true ),
        Template.new( :mini_cart, 'cart/mini_cart', :partial => true ),
        Template.new( :mini_cart_item, 'cart/mini_cart_item', :partial => true ),
        Template.new( :mini_cart_footer, 'cart/mini_cart_footer', :partial => true ),
        Template.new( :upsell, 'cart/upsell', :partial => true ),
        Template.new( :upsell_product, 'cart/upsell_product', :partial => true ),
        Template.new( :security, 'shared/security', :partial => true ),
        Template.new( :cart_title, 'cart/cart_title', :partial => true),
        #Checkout
        Template.new( :shipping_methods, 'checkout/shipping_methods', :partial => true),
        Template.new( :layout, 'application', :no_default => true ),
        Template.new( :snippet_layout, 'snippet', :no_default => true ),
        Template.new( :navigation, 'shared/navigation_element', :shared => true, :partial => true ),
        Template.new( :order_contents, "shared/order_contents", :partial => true),
        Template.new( :checkout_result, 'checkout/result'),
        Template.new( :order_gift_messages, 'checkout/order_gift_messages', :partial => true),
        Template.new( :order_gift_message_display, 'shared/order_gift_message_display', :partial => true),
        Template.new( :order_display, 'shared/order_display', :partial => true),
        Template.new( :checkout_indicator, 'checkout/indicator', :partial => true),
        Template.new( :tax_footnotes, 'shared/tax_footnotes', :partial => true),
        #Pages
        Template.new( :page, 'pages/show' ),
        Template.new( :page_not_found, 'pages/page_not_found' ),
        Template.new( :index, 'pages/index' ),
        #News
        Template.new( :news_category, 'news_categories/show'),
        Template.new( :news, 'news_items/show' ),
        Template.new( :news_index, 'news_items/index' ),
        #Periodic Content
        Template.new( :periodic_content, 'periodic_contents/show' ),
        Template.new( :periodic_content_products, 'periodic_contents/products'),
        Template.new( :periodic_content_search, 'periodic_contents/search'),
        Template.new( :periodic_content_search_form, 'periodic_contents/search_form', :partial => true),
        Template.new( :periodic_content_product_form, 'periodic_contents/product_form', :partial => true),
        Template.new( :periodic_content_license_form, 'periodic_contents/license_form', :partial => true),
        Template.new( :periodic_content_product_image, 'periodic_contents/product_image', :partial => true),
        Template.new( :periodic_content_product_details, 'periodic_contents/product_details', :partial => true),
        #Survey
        Template.new( :survey, "surveys/show" ),
        Template.new( :survey_question, "surveys/question", :partial => true ),
        Template.new( :survey_response, 'survey_responses/show' ),
        Template.new( :poll, "surveys/poll", :partial => true),
        Template.new( :poll_result, "surveys/poll_result", :partial => true),
        #Dynamic Content
        Template.new( :swap_dynamic_product, "dynamic_contents/swap_product", :partial => true),
        Template.new( :swap_category_product, "categories/swap_product", :partial => true),
        Template.new( :spot_snippet, 'snippets/spot'),
        Template.new( :dynamic_spot_snippet, 'snippets/dynamic_spot'),
        #Customer
        Template.new( :login, "customer_sessions/new"),
        Template.new( :login_form, "customer_sessions/form", :partial => true),
        Template.new( :login_popup_form, "customer_sessions/popup_form", :partial => true),
        Template.new( :forgot_password, "customer_sessions/forgot_password"),
        Template.new( :forgot_password_form, "customer_sessions/forgot_password_form", :partial=>true),
        Template.new( :forgot_password_popup_form, "customer_sessions/forgot_password_popup_form", :partial=>true),
        Template.new( :new_customer, "customers/new"),
        Template.new( :new_customer_form, "customers/form", :partial => true),
        Template.new( :new_customer_popup_form, "customers/popup_form", :partial => true),
        Template.new( :newsletter_signup_form, "shared/newsletter_signup_form", :partial => true),
        #Contact
        Template.new( :contact, "contacts/index")
      ].collect {|t| [t.short_name, t] }.flatten ]
    end

    ## Need a way to clear the cache for a site.  --JonMoses TODO
    def find( site_or_id, short_name )
      site_id = ( site_or_id.is_a?(Site) ? site_or_id.id.to_s : site_or_id.to_s )

      site_cache = ( @@template_cache[site_id] ||= {} )
      template = lookup(short_name)
      
      if site_cache and site_cache.keys.include?(short_name) ## Return even if value is nil
        site_cache[short_name]
      else
        site_path = ( site_or_id.is_a?(Site) ? site_or_id.filepath : Site.find(site_or_id).filepath)

        if path = check_site_specific(site_path, short_name)
          site_cache[short_name] = SiteTemplate.new(template, path)
        else
          site_cache[short_name] = ( template.no_default ? nil : SiteTemplate.new(template, nil) )
        end
      end
    end
    
    def check_site_specific( site_path, short_name )
      template = lookup(short_name)
      if entries = Dir[File.join( Rails.root, 'app', 'views', 'site_templates', site_path, "#{template.file_path}.*")] and ! entries.empty?
        File.join( 'site_templates', site_path, template.path)
      else
        false
      end
    end
    
    def lookup( short_name )
      map[short_name]
    end

  end
  
end