module TemplateFinder
  ## Still need this to be "reloadable", I think.
  class Template
    attr_reader :short_name, :path, :file_path, :no_default
  
    # Parameters:
    # +short_name+:: Name to use (as a symbol) when we want to render this template
    # +path+:: Path (relative to 'app/views' or the site root) where the template will be
    #          including the filename of the templat, but _not_ the extention.
    #          IE: "products/list", not "products/list.html.erb"
    # +options+:: Hash of options
    #
    # Options::
    # +partial+:: True if this template is a partial, default is false
    # +shared+:: True if this template lives in the "shared" directory, default is false
    # +no_default+:: True if there is no default template for this (like the layout), default is false
    def initialize( short_name, path, options = {} )
      @short_name = short_name
      @path = path
      @partial = ( options[:partial] or false )
      @shared = ( options[:shared] or false )
      @no_default = (options[:no_default] or false )
    
      path_parts = File.split( @path )
      path_parts.shift if @shared
      path_parts[-1] = "_#{path_parts[-1]}" if @partial
    
      @file_path = File.join( path_parts )
    end
  
    def partial?
      @partial
    end
  
    def shared?
      @shared
    end
  
  end
end