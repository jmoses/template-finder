module TemplateFinder
  module HelperMethods
    ## Need to DRY this from above.
    def render_for( short_name, options = {})
      template = template_for(short_name)
      render options.merge(template.to_params)
    end  
  
    def partial_for( partial, options = {} )
      begin
        render options.merge(:partial => "site_templates/#{site.filepath}/#{partial}")
      rescue ActionView::MissingTemplate
        render options.merge(:partial => "site_templates/#{site.filepath}/#{partial}")
      end
    end
  end
end