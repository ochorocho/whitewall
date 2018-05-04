module Whitewall
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
		  content = stylesheet_link_tag('app.css', :plugin => 'whitewall') + javascript_include_tag('app.js', :plugin => 'whitewall')
      end
    end
  end
end