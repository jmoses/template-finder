module TemplateFinder
  class SiteTemplate
    attr_reader :path
    def initialize( template, site_path )
      @template = template
      @path = ( site_path or template.path )
    end
    
    def partial?
      @template.partial?
    end
    
    def shared?
      @template.shared?
    end
    
    def render_key
      partial? ? :partial : :template
    end
    
    def to_params
      {render_key => self.path}
    end
    
  end
end