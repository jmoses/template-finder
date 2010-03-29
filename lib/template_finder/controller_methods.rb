module TemplateFinder
  module ControllerMethods
    def self.included( base )
      base.class_eval do
        include InstanceMethods
      
        helper_method :template_for
      end
    end

    module InstanceMethods
      def template_for( short_name )
        begin
          TemplateFinder::Mapper.find( site, short_name )
        rescue ActiveRecord::RecordNotFound
          TemplateFinder::Mapper.find( admin_site, short_name )
        end
      end
    
      ## Need a version of this for the application helper
      ## since `render` is different in the controller vs
      ## the view.  
      def render_for( short_name, options = {})
        template = template_for(short_name)
        render options.merge(template.to_params)
      end
    end
  
  end
end