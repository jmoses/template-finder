require 'template_finder'

ActionController::Base.send(:include, TemplateFinder::ControllerMethods )
ActionView::Base.send(:include, TemplateFinder::HelperMethods ) ## This only works once!?????