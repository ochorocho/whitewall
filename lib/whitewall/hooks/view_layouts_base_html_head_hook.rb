module Whitewall
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})

        content = stylesheet_link_tag('app.css', :plugin => 'whitewall')
        content += javascript_include_tag 'jquery.ba-throttle-debounce', :plugin => 'whitewall'
        content += javascript_include_tag 'jquery.stickyheader', :plugin => 'whitewall'
        content += javascript_include_tag 'app', :plugin => 'whitewall'

      end
    end
  end
end